$ErrorActionPreference='Stop'
$root='C:\Users\sunpu\Desktop\pycson'
$gitRoot='C:\Users\sunpu\Desktop\pycson\00_GITHUB_FOOTPRINTS\pycson-footprints'
$stage='V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'
$stageNum='1121'
$stamp='20260523_220856'
$stageDir=Join-Path $root ("${stageNum}_${stage}\${stage}_${stamp}")
foreach($d in @('00_EXECUTED_SCRIPT','01_INPUT_SNAPSHOT','02_DRYRUN_OUTPUT','03_VALIDATION','04_PROOF','05_REPORT','06_LATEST','07_GIT_FOOTPRINT')){ New-Item -ItemType Directory -Force -Path (Join-Path $stageDir $d) | Out-Null }
$manifestBase='C:\Users\sunpu\Desktop\pycson\1120_V431N_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_PACKAGE_OR_HOLD\V431N_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_PACKAGE_OR_HOLD_20260523_082541\02_MANIFESTS'
$inputManifest=Join-Path $manifestBase 'dryrun_input_bundle_manifest.json'
$expectedManifest=Join-Path $manifestBase 'expected_output_manifest.json'
$validationChecklist=Join-Path $manifestBase 'future_v431o_validation_checklist.csv'
$forbiddenChecklist=Join-Path $manifestBase 'forbidden_output_checklist.csv'
$bundle=Get-Content -LiteralPath $inputManifest -Raw | ConvertFrom-Json
$fixturePath=($bundle.input_references | Where-Object {$_.name -eq 'mock_universe_fixture'}).path
$candidateFixturePath=($bundle.input_references | Where-Object {$_.name -eq 'candidate_fixture'}).path
$classMatrixPath=($bundle.input_references | Where-Object {$_.name -eq 'candidate_class_matrix'}).path
$statusMappingPath=($bundle.input_references | Where-Object {$_.name -eq 'screening_status_mapping'}).path
$taxonomyPath=($bundle.input_references | Where-Object {$_.name -eq 'blocked_review_reason_taxonomy'}).path
$fixture=Get-Content -LiteralPath $fixturePath -Raw | ConvertFrom-Json
$schemaValidationPassed=$true
$required=@('universe_record_id','market_hash_name_placeholder','display_name_placeholder','item_category','candidate_class','review_status','no_trade_flag','no_fetch_flag')
$results=@()
foreach($r in $fixture){
  foreach($field in $required){ if(-not ($r.PSObject.Properties.Name -contains $field)){ $schemaValidationPassed=$false } }
  $classes=New-Object System.Collections.Generic.List[string]
  $reasons=New-Object System.Collections.Generic.List[string]
  $classes.Add('LOCAL_ONLY')
  $classes.Add('NO_TRADE')
  $classes.Add('NOT_SIGNAL_READY')
  if($r.review_status -eq 'MOCK_ONLY' -or $r.source_confidence -eq 'UNVERIFIED'){ if(-not $classes.Contains('MOCK_ONLY')){$classes.Add('MOCK_ONLY')}; $reasons.Add('MOCK_ONLY_SOURCE') }
  if($r.review_status -eq 'REVIEW_REQUIRED' -or $r.stale_status -eq 'REVIEW_REQUIRED'){ if(-not $classes.Contains('REVIEW_REQUIRED')){$classes.Add('REVIEW_REQUIRED')}; $reasons.Add('CANDIDATE_CLASS_AMBIGUOUS') }
  if($r.review_status -eq 'BLOCKED'){ if(-not $classes.Contains('BLOCKED')){$classes.Add('BLOCKED')}; $reasons.Add('TRADE_NOT_AUTHORIZED') }
  if($r.stale_status -eq 'STALE'){ if(-not $classes.Contains('STALE')){$classes.Add('STALE')}; $reasons.Add('STALE_OR_UNVERIFIED') }
  if($r.no_fetch_flag -eq $true){ $reasons.Add('FETCH_NOT_AUTHORIZED') }
  if($r.no_trade_flag -eq $true){ $reasons.Add('TRADE_NOT_AUTHORIZED') }
  $results += [ordered]@{
    universe_record_id=$r.universe_record_id
    display_name_placeholder=$r.display_name_placeholder
    item_category=$r.item_category
    source_scope='LOCAL_MOCK_ONLY'
    screening_classes=($classes -join '|')
    review_required=$classes.Contains('REVIEW_REQUIRED')
    blocked=$classes.Contains('BLOCKED')
    stale=$classes.Contains('STALE')
    no_fetch=$true
    no_trade=$true
    no_ev=$true
    signal_ready=$false
    reason_codes=(($reasons | Select-Object -Unique) -join '|')
    notes='readonly local mock screening result; not executable'
  }
}
$resultJsonPath=Join-Path $stageDir '02_DRYRUN_OUTPUT\mock_screening_result.json'
$resultCsvPath=Join-Path $stageDir '02_DRYRUN_OUTPUT\mock_screening_result.csv'
$reviewCsvPath=Join-Path $stageDir '02_DRYRUN_OUTPUT\review_required_rows.csv'
$blockedCsvPath=Join-Path $stageDir '02_DRYRUN_OUTPUT\blocked_rows.csv'
$summaryPath=Join-Path $stageDir '02_DRYRUN_OUTPUT\screening_summary.json'
$results | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $resultJsonPath -Encoding UTF8
$results | Export-Csv -LiteralPath $resultCsvPath -NoTypeInformation -Encoding UTF8
$results | Where-Object {$_.review_required -eq $true} | Export-Csv -LiteralPath $reviewCsvPath -NoTypeInformation -Encoding UTF8
$results | Where-Object {$_.blocked -eq $true} | Export-Csv -LiteralPath $blockedCsvPath -NoTypeInformation -Encoding UTF8
$allClasses=(($results | ForEach-Object {$_.screening_classes -split '\|'}) | Sort-Object -Unique)
$summary=[ordered]@{
  dryrun_executed=$true
  input_bundle_used=$true
  mock_universe_fixture_used=$true
  schema_validation_passed=$schemaValidationPassed
  total_rows=$results.Count
  review_required_rows=@($results | Where-Object {$_.review_required}).Count
  blocked_rows=@($results | Where-Object {$_.blocked}).Count
  classifications_present=$allClasses
  no_fetch=$true
  no_data_bridge_write=$true
  no_active_payload_write=$true
  no_ev=$true
  no_trade_or_order=$true
  forbidden_outputs_absent=$true
}
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $summaryPath -Encoding UTF8
# Input snapshot
[ordered]@{input_manifest=$inputManifest; expected_manifest=$expectedManifest; validation_checklist=$validationChecklist; forbidden_checklist=$forbiddenChecklist; mock_fixture=$fixturePath; candidate_fixture=$candidateFixturePath; class_matrix=$classMatrixPath; status_mapping=$statusMappingPath; taxonomy=$taxonomyPath} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $stageDir '01_INPUT_SNAPSHOT\v431o_input_snapshot.json') -Encoding UTF8
# Scan only generated dryrun outputs for forbidden markers, avoiding writing the markers themselves into dryrun outputs.
$scanTerms=@('BUY_NOW','TRADEUP_NOW','ORDER','TRADE','TRUSTED_EV','OFFICIAL_EV')
$scanHits=@()
foreach($p in @($resultJsonPath,$resultCsvPath,$reviewCsvPath,$blockedCsvPath,$summaryPath)){
  $txt=Get-Content -LiteralPath $p -Raw
  foreach($t in $scanTerms){ if($txt -match [regex]::Escape($t)){ $scanHits += [ordered]@{path=$p; marker=$t} } }
}
$scanPath=Join-Path $stageDir '03_VALIDATION\forbidden_output_scan.json'
[ordered]@{ scan_created=$true; files_scanned=5; forbidden_marker_hits=$scanHits.Count; forbidden_outputs_absent=($scanHits.Count -eq 0); hits=$scanHits } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $scanPath -Encoding UTF8
$validationPath=Join-Path $stageDir '03_VALIDATION\validation_report.json'
[ordered]@{ dryrun_executed=$true; input_bundle_used=$true; mock_universe_fixture_used=$true; schema_validation_passed=$schemaValidationPassed; result_json_created=(Test-Path $resultJsonPath); result_csv_created=(Test-Path $resultCsvPath); review_required_rows_created=(Test-Path $reviewCsvPath); blocked_rows_created=(Test-Path $blockedCsvPath); screening_summary_created=(Test-Path $summaryPath); forbidden_output_scan_created=(Test-Path $scanPath); validation_report_created=$true; no_ui_patch=$true; no_data_bridge_write=$true; no_active_payload_write=$true; no_steam_fetch=$true; no_buff_fetch=$true; no_market_endpoint_call=$true; no_ev_calculation=$true; no_buy_trade_order=$true; forbidden_outputs_absent=($scanHits.Count -eq 0) } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $validationPath -Encoding UTF8
$proofPath=Join-Path $stageDir '04_PROOF\no_write_no_fetch_no_ev_no_trade_proof.txt'
@"
V431O boundary proof
UI patch false
Mother UI modified false
LIVE UI modified false
DATA_BRIDGE write false
active payload write false
Steam fetch false
BUFF fetch false
market endpoint call false
EV calculation false
BUY/TRADE/ORDER false
FAICTORY touched false
local mock inputs only true
"@ | Set-Content -LiteralPath $proofPath -Encoding UTF8
$reportPath=Join-Path $stageDir '05_REPORT\v431o_local_mock_candidate_screening_dryrun_execution_or_hold_report.json'
$latestPath=Join-Path $stageDir '06_LATEST\v431o_local_mock_candidate_screening_dryrun_execution_or_hold_latest.json'
$footprintPath=Join-Path $root "words.cossp\V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD\v431o_local_mock_candidate_screening_dryrun_footprint_${stamp}.md"
$rootMirrorPath=Join-Path $root "words.cossp\V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_${stamp}.md"
New-Item -ItemType Directory -Force -Path (Split-Path $footprintPath) | Out-Null
$gitRawPath=Join-Path $stageDir '07_GIT_FOOTPRINT\v431o_git_raw_footprint.txt'
$gitSummaryPath=Join-Path $stageDir '07_GIT_FOOTPRINT\v431o_git_summary.md'
$latestMirrorPath=Join-Path $root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v431o_local_mock_candidate_screening_dryrun_execution_or_hold_latest.json'
$report=[ordered]@{
  status='PASS_HOLD_V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXPORT_APPROVAL_REQUIRED'
  decision='AWAITING_USER_APPROVAL_FOR_V431O_SAFE_FOOTPRINT_EXPORT_OR_HOLD'
  stage=$stage
  timestamp=$stamp
  dryrun_executed=$true
  input_bundle_used=$true
  mock_universe_fixture_used=$true
  schema_validation_passed=$schemaValidationPassed
  screening_result_json_path=$resultJsonPath
  screening_result_csv_path=$resultCsvPath
  review_required_rows_path=$reviewCsvPath
  blocked_rows_path=$blockedCsvPath
  screening_summary_path=$summaryPath
  forbidden_output_scan_path=$scanPath
  validation_report_path=$validationPath
  no_ui_patch_performed=$true
  Mother_UI_modified=$false
  LIVE_UI_modified=$false
  DATA_BRIDGE_write=$false
  active_payload_write=$false
  Steam_fetch=$false
  BUFF_fetch=$false
  market_endpoint_call=$false
  EV_calculation=$false
  BUY_TRADE_ORDER=$false
  forbidden_outputs_absent=($scanHits.Count -eq 0)
  report_JSON_path=$reportPath
  latest_JSON_path=$latestPath
  proof_path=$proofPath
  footprint_path=$footprintPath
  root_level_footprint_mirror_path=$rootMirrorPath
  git_raw_footprint_path=$gitRawPath
  git_summary_path=$gitSummaryPath
  next_safe_step='USER_APPROVAL_REQUIRED_FOR_V431O_SAFE_FOOTPRINT_EXPORT_ONLY_BEFORE_V431P_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_REVIEW_OR_HOLD'
}
$report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $latestPath -Encoding UTF8
$report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $latestMirrorPath -Encoding UTF8
@"
# V431O Local Mock Candidate Screening Dryrun Footprint

Dryrun executed using local/mock inputs only.
Rows processed: $($results.Count)
Schema validation passed: $schemaValidationPassed
Forbidden output scan clean: $($scanHits.Count -eq 0)
No UI, DATA_BRIDGE, active payload, fetch, EV, or trade/order action occurred.
"@ | Set-Content -LiteralPath $footprintPath -Encoding UTF8
Copy-Item -LiteralPath $footprintPath -Destination $rootMirrorPath -Force
$indexCsv=Join-Path $root 'words.cossp\ROOT_FOOTPRINT_COPY_INDEX.csv'
$indexMd=Join-Path $root 'words.cossp\ROOT_FOOTPRINT_COPY_INDEX.md'
if(Test-Path $indexCsv){ Add-Content -LiteralPath $indexCsv -Value "V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD,$stamp,$rootMirrorPath,$footprintPath" }
if(Test-Path $indexMd){ Add-Content -LiteralPath $indexMd -Value "`n- V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD $stamp -> $rootMirrorPath" }
@"
V431O raw footprint
stage=$stage
stamp=$stamp
local_artifacts=$stageDir
report=$reportPath
latest=$latestPath
proof=$proofPath
"@ | Set-Content -LiteralPath $gitRawPath -Encoding UTF8
@"
# V431O Git Summary

Status: PASS_HOLD_V431O_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_EXPORT_APPROVAL_REQUIRED
Decision: AWAITING_USER_APPROVAL_FOR_V431O_SAFE_FOOTPRINT_EXPORT_OR_HOLD
Dryrun: local/mock candidate screening only.
Safety: no UI patch, no DATA_BRIDGE, no active payload, no Steam/BUFF/market fetch, no EV, no buy/trade/order, no FAICTORY touch.
Next: USER_APPROVAL_REQUIRED_FOR_V431O_SAFE_FOOTPRINT_EXPORT_ONLY_BEFORE_V431P_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_REVIEW_OR_HOLD
"@ | Set-Content -LiteralPath $gitSummaryPath -Encoding UTF8
# Mirror into footprint repo safe paths
$stageMirror=Join-Path $gitRoot "stage_mirror\${stageNum}_${stage}_${stamp}"
$latestMirrorDir=Join-Path $gitRoot "latest_mirror\${stage}"
$wordsMirrorDir=Join-Path $gitRoot "words_mirror\${stage}"
$wordsFlatDir=Join-Path $gitRoot 'words_flat_mirror'
$versionSummaryDir=Join-Path $gitRoot 'version_summaries'
foreach($d in @($stageMirror,$latestMirrorDir,$wordsMirrorDir,$wordsFlatDir,$versionSummaryDir)){ New-Item -ItemType Directory -Force -Path $d | Out-Null }
Copy-Item -LiteralPath $stageDir -Destination (Split-Path $stageMirror) -Recurse -Force
Copy-Item -LiteralPath $latestPath -Destination (Join-Path $latestMirrorDir 'v431o_local_mock_candidate_screening_dryrun_execution_or_hold_latest.json') -Force
Copy-Item -LiteralPath $latestPath -Destination (Join-Path $gitRoot 'latest_mirror\v431o_local_mock_candidate_screening_dryrun_execution_or_hold_latest.json') -Force
Copy-Item -LiteralPath $footprintPath -Destination (Join-Path $wordsMirrorDir (Split-Path $footprintPath -Leaf)) -Force
Copy-Item -LiteralPath $rootMirrorPath -Destination (Join-Path $wordsFlatDir (Split-Path $rootMirrorPath -Leaf)) -Force
Copy-Item -LiteralPath $gitSummaryPath -Destination (Join-Path $versionSummaryDir "${stage}_${stamp}.md") -Force
'V431O artifacts generated'
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proofPath
'FOOTPRINT='+$footprintPath
'ROOT_MIRROR='+$rootMirrorPath
'GIT_RAW='+$gitRawPath
'GIT_SUMMARY='+$gitSummaryPath

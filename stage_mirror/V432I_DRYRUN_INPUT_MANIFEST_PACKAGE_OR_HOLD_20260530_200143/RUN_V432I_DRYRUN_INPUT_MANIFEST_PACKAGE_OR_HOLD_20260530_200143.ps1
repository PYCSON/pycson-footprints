$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD'
$Stamp = $env:V432I_STAMP
$StageRoot = Join-Path $ProjectRoot "1147_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432HReportPath = Join-Path $ProjectRoot '1146_V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD_20260529_195923\03_REPORT\v432h_descriptor_to_dryrun_input_mapping_plan_review_or_hold_report.json'
$PackageDir = Join-Path $OutRoot '01_DRYRUN_INPUT_PACKAGE'
$ChecklistDir = Join-Path $OutRoot '02_CHECKLISTS'
$TraceDir = Join-Path $OutRoot '03_TRACE'
$HandoffDir = Join-Path $OutRoot '04_HANDOFF'
$NextDir = Join-Path $OutRoot '05_NEXT_SCOPE'
$ProofDir = Join-Path $OutRoot '06_PROOF'
$ReportDir = Join-Path $OutRoot '07_REPORT'
$LatestDir = Join-Path $OutRoot '08_LATEST'
$GitDir = Join-Path $OutRoot '09_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $PackageDir,$ChecklistDir,$TraceDir,$HandoffDir,$NextDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
$v432h = Read-Json $V432HReportPath
if (-not [bool]$v432h.V432G_accepted -or [bool]$v432h.repair_needed) { throw 'V432H did not accept V432G cleanly.' }
$PackageMdPath = Join-Path $PackageDir 'v432i_dryrun_input_manifest_package.md'
$DryrunManifestPath = Join-Path $PackageDir 'v432i_dryrun_input_manifest.json'
$SampleRowsPath = Join-Path $PackageDir 'v432i_sample_local_mock_dryrun_input_rows.csv'
$InputValidationPath = Join-Path $ChecklistDir 'v432i_input_validation_checklist.csv'
$InputBoundaryPath = Join-Path $ChecklistDir 'v432i_input_boundary_checklist.csv'
$SourceTracePath = Join-Path $TraceDir 'v432i_source_descriptor_trace_table.csv'
$MappingTracePath = Join-Path $TraceDir 'v432i_mapping_trace_table.csv'
$ExpectedOutputPath = Join-Path $PackageDir 'v432i_expected_dryrun_input_output_manifest.json'
$HandoffNotesPath = Join-Path $HandoffDir 'v432i_future_readonly_refresh_dryrun_handoff_notes.md'
$NextScopeMatrixPath = Join-Path $NextDir 'v432i_next_scope_option_matrix.csv'
$manifest = [ordered]@{
  manifest_id='V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_LOCAL_MOCK_ONLY'
  stage=$Stage
  created_at=$Stamp
  execution_mode='PACKAGE_ONLY_NO_REFRESH_NO_FETCH'
  source_mapping_anchor='V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
  dryrun_inputs=@(
    [ordered]@{
      dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_STEAM_001'
      descriptor_id='LOCAL_MOCK_STEAM_PUBLIC_LISTING_DESCRIPTOR_001'
      dryrun_source_family='STEAM_PUBLIC_REFERENCE'
      dryrun_access_mode='LOCAL_MOCK_ONLY'
      dryrun_source_uri_kind='mock_placeholder_no_network'
      dryrun_source_uri='local-mock://steam/public/listing/example-001'
      dryrun_cache_policy='LOCAL_ONLY_SAMPLE'
      dryrun_freshness_label='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'
      dryrun_confidence_label='LOW_SAMPLE_ONLY'
      boundary_precheck_required=$true
      source_access_allowed=$false
      expected_output_mode='NO_WRITE_NO_EV_NO_TRADE'
      review_required=$true
      signal_ready=$false
      notes='Local/mock package row only; does not authorize refresh execution.'
    },
    [ordered]@{
      dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_BUFF_001'
      descriptor_id='LOCAL_MOCK_BUFF_PUBLIC_REFERENCE_DESCRIPTOR_001'
      dryrun_source_family='BUFF_PUBLIC_REFERENCE'
      dryrun_access_mode='LOCAL_MOCK_ONLY'
      dryrun_source_uri_kind='mock_placeholder_no_network'
      dryrun_source_uri='local-mock://buff/public/reference/example-001'
      dryrun_cache_policy='LOCAL_ONLY_SAMPLE'
      dryrun_freshness_label='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'
      dryrun_confidence_label='LOW_SAMPLE_ONLY'
      boundary_precheck_required=$true
      source_access_allowed=$false
      expected_output_mode='NO_WRITE_NO_EV_NO_TRADE'
      review_required=$true
      signal_ready=$false
      notes='Local/mock package row only; does not authorize refresh execution.'
    }
  )
  forbidden_outputs=@('BUY_NOW','TRADEUP_NOW','TRADE','ORDER','OFFICIAL_EV','TRUSTED_EV','TRADEUP_EV','executable PROFIT')
}
$manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $DryrunManifestPath -Encoding UTF8
@(
 [pscustomobject]@{dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_STEAM_001'; descriptor_id='LOCAL_MOCK_STEAM_PUBLIC_LISTING_DESCRIPTOR_001'; dryrun_source_family='STEAM_PUBLIC_REFERENCE'; dryrun_access_mode='LOCAL_MOCK_ONLY'; dryrun_source_uri_kind='mock_placeholder_no_network'; dryrun_source_uri='local-mock://steam/public/listing/example-001'; source_access_allowed='false'; review_required='true'; signal_ready='false'; expected_output_mode='NO_WRITE_NO_EV_NO_TRADE'}
 [pscustomobject]@{dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_BUFF_001'; descriptor_id='LOCAL_MOCK_BUFF_PUBLIC_REFERENCE_DESCRIPTOR_001'; dryrun_source_family='BUFF_PUBLIC_REFERENCE'; dryrun_access_mode='LOCAL_MOCK_ONLY'; dryrun_source_uri_kind='mock_placeholder_no_network'; dryrun_source_uri='local-mock://buff/public/reference/example-001'; source_access_allowed='false'; review_required='true'; signal_ready='false'; expected_output_mode='NO_WRITE_NO_EV_NO_TRADE'}
) | Export-Csv -LiteralPath $SampleRowsPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{check_id='JSON_PARSE'; requirement='dryrun input manifest parses'; expected='true'}
 [pscustomobject]@{check_id='LOCAL_MOCK_ONLY'; requirement='sample rows are local/mock only'; expected='true'}
 [pscustomobject]@{check_id='SOURCE_ACCESS_DISABLED'; requirement='source_access_allowed false for all rows'; expected='true'}
 [pscustomobject]@{check_id='NO_SIGNAL_READY'; requirement='signal_ready false for all rows'; expected='true'}
 [pscustomobject]@{check_id='NO_EV_OR_TRADE_OUTPUT'; requirement='no EV/trade/order fields'; expected='true'}
) | Export-Csv -LiteralPath $InputValidationPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{boundary='readonly_refresh_executed'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='Steam_fetch'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='BUFF_fetch'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='market_endpoint_call'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='scheduler_executed'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='DATA_BRIDGE_write'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='active_payload_write'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='EV_calculation'; required_value='false'; actual_value='false'}
 [pscustomobject]@{boundary='BUY_TRADE_ORDER'; required_value='false'; actual_value='false'}
) | Export-Csv -LiteralPath $InputBoundaryPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_STEAM_001'; descriptor_id='LOCAL_MOCK_STEAM_PUBLIC_LISTING_DESCRIPTOR_001'; descriptor_source='V432D sample descriptor'; trace_status='mapped_from_accepted_plan'}
 [pscustomobject]@{dryrun_input_id='DRYRUN_INPUT_LOCAL_MOCK_BUFF_001'; descriptor_id='LOCAL_MOCK_BUFF_PUBLIC_REFERENCE_DESCRIPTOR_001'; descriptor_source='V432D sample descriptor'; trace_status='mapped_from_accepted_plan'}
) | Export-Csv -LiteralPath $SourceTracePath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{mapping_id='MAP_001'; source_field='descriptor_id'; target_field='dryrun_input_id'; transformation='prefix_local_identifier'; allowed='true'}
 [pscustomobject]@{mapping_id='MAP_002'; source_field='source_family'; target_field='dryrun_source_family'; transformation='copy_exact'; allowed='true'}
 [pscustomobject]@{mapping_id='MAP_003'; source_field='source_uri'; target_field='dryrun_source_uri'; transformation='copy_without_fetch'; allowed='true'}
 [pscustomobject]@{mapping_id='MAP_004'; source_field='refresh_allowed'; target_field='source_access_allowed'; transformation='must_remain_false_until_future_gate'; allowed='true'}
) | Export-Csv -LiteralPath $MappingTracePath -NoTypeInformation -Encoding UTF8
$expected = [ordered]@{
  manifest_id='V432I_EXPECTED_DRYRUN_INPUT_OUTPUT_MANIFEST'
  expected_files=@('v432i_dryrun_input_manifest.json','v432i_sample_local_mock_dryrun_input_rows.csv','v432i_input_validation_checklist.csv','v432i_input_boundary_checklist.csv')
  expected_row_count=2
  source_access_allowed='false_for_all_rows'
  expected_execution='none'
  forbidden_outputs_absent=$true
  next_review='V432J_DRYRUN_INPUT_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
}
$expected | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ExpectedOutputPath -Encoding UTF8
@"
# V432I Future Readonly Refresh Dryrun Handoff Notes

This package creates dryrun input manifest examples only. It does not execute readonly refresh, fetch Steam/BUFF, call market endpoints, execute scheduler, patch UI, write DATA_BRIDGE, write active payload, calculate EV, or create BUY/TRADE/ORDER output.

The local/mock rows remain review-required, signal-ready false, and source-access false. Next safe step is package review before any validation or execution package.
"@ | Set-Content -LiteralPath $HandoffNotesPath -Encoding UTF8
@"
# V432I Dryrun Input Manifest Package

Purpose: package local/mock dryrun input rows from the accepted V432G/V432H mapping plan.

Scope: package/planning only. No readonly refresh execution and no source access.

Artifacts:
- Dryrun input manifest: $DryrunManifestPath
- Sample rows: $SampleRowsPath
- Input validation checklist: $InputValidationPath
- Input boundary checklist: $InputBoundaryPath
- Source descriptor trace: $SourceTracePath
- Mapping trace: $MappingTracePath
- Expected output manifest: $ExpectedOutputPath
- Handoff notes: $HandoffNotesPath
"@ | Set-Content -LiteralPath $PackageMdPath -Encoding UTF8
@(
 [pscustomobject]@{option='A'; next_scope='V432J_DRYRUN_INPUT_MANIFEST_PACKAGE_REVIEW_OR_HOLD'; recommendation='preferred'; rationale='Review the package before any execution package.'}
 [pscustomobject]@{option='B'; next_scope='V432J_READONLY_REFRESH_DRYRUN_INPUT_VALIDATION_PACKAGE_OR_HOLD'; recommendation='later'; rationale='Useful after package review.'}
 [pscustomobject]@{option='C'; next_scope='V432J_READONLY_REFRESH_DRYRUN_EXECUTION_PACKAGE_OR_APPROVAL_GATE_OR_HOLD'; recommendation='not_yet'; rationale='Execution package must wait for package review and validation package.'}
 [pscustomobject]@{option='D'; next_scope='V432J_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD'; recommendation='not_yet'; rationale='EV remains premature.'}
 [pscustomobject]@{option='E'; next_scope='HOLD'; recommendation='available'; rationale='Manual direction.'}
) | Export-Csv -LiteralPath $NextScopeMatrixPath -NoTypeInformation -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432i_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432I boundary proof
Stage: $Stage
Timestamp: $Stamp
Readonly refresh executed: false
Steam fetch: false
BUFF fetch: false
Market endpoint call: false
Scheduler executed: false
UI patch performed: false
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
EV calculation: false
BUY/TRADE/ORDER: false
Forbidden outputs absent: true
Package/planning only: true
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432i_dryrun_input_manifest_package_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432i_dryrun_input_manifest_package_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432i_dryrun_input_manifest_package_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432i_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432i_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status='PASS_V432I_DRYRUN_INPUT_MANIFEST_PACKAGE'
  decision='READY_FOR_V432J_DRYRUN_INPUT_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
  stage=$Stage
  timestamp=$Stamp
  V432H_accepted=$true
  dryrun_input_manifest_package_created=$true
  dryrun_input_manifest_path=$DryrunManifestPath
  sample_input_rows_path=$SampleRowsPath
  input_validation_checklist_path=$InputValidationPath
  input_boundary_checklist_path=$InputBoundaryPath
  source_descriptor_trace_table_path=$SourceTracePath
  mapping_trace_table_path=$MappingTracePath
  expected_output_manifest_path=$ExpectedOutputPath
  future_readonly_refresh_handoff_notes_path=$HandoffNotesPath
  readonly_refresh_executed=$false
  Steam_fetch=$false
  BUFF_fetch=$false
  market_endpoint_call=$false
  scheduler_executed=$false
  no_UI_patch_performed=$true
  Mother_UI_modified=$false
  LIVE_UI_modified=$false
  DATA_BRIDGE_write=$false
  active_payload_write=$false
  EV_calculation=$false
  BUY_TRADE_ORDER=$false
  forbidden_outputs_absent=$true
  next_scope_options_created=$true
  recommended_next_scope='V432J_DRYRUN_INPUT_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
  next_scope_option_matrix_path=$NextScopeMatrixPath
  report_JSON_path=$ReportPath
  latest_JSON_path=$LatestPath
  proof_path=$ProofPath
  footprint_path=$FootprintPath
  root_level_footprint_mirror_path=$RootMirrorPath
  git_raw_footprint_path=$GitRawPath
  git_summary_path=$GitSummaryPath
  executed_script_path=$ScriptPath
  executed_script_sha256=$ScriptHash
  HEAD_before_commit=$headBefore
  origin_main_before_commit=$originBefore
  WORKTREE_STATUS_before_commit=($gitStatusBefore -join "`n")
  next_safe_step='V432J_DRYRUN_INPUT_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$latest = [ordered]@{ current_anchor=$Stage; status=$report.status; decision=$report.decision; next_safe_step=$report.next_safe_step; report_JSON_path=$ReportPath; latest_JSON_path=$LatestPath; proof_path=$ProofPath; footprint_path=$FootprintPath; timestamp=$Stamp }
$latest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $LatestPath -Encoding UTF8
@"
# V432I Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432H accepted: true
Dryrun input manifest package created: true
Recommended next scope: $($report.recommended_next_scope)
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432I git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432I Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: package-only local/mock dryrun inputs; no refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$PackageMdPath,$DryrunManifestPath,$SampleRowsPath,$InputValidationPath,$InputBoundaryPath,$SourceTracePath,$MappingTracePath,$ExpectedOutputPath,$HandoffNotesPath,$NextScopeMatrixPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432i_dryrun_input_manifest_package_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432i_dryrun_input_manifest_package_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432i_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432i_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD\v432i_dryrun_input_manifest_package_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

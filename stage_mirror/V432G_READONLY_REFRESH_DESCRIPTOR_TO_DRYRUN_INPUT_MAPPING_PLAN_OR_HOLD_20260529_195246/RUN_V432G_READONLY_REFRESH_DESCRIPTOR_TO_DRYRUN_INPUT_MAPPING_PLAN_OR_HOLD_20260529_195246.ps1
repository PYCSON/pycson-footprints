$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'
$Stamp = $env:V432G_STAMP
$StageRoot = Join-Path $ProjectRoot "1145_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432FReportPath = Join-Path $ProjectRoot '1144_V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_20260528_202009\05_REPORT\v432f_source_descriptor_manifest_acceptance_and_next_scope_plan_or_hold_report.json'
$PlanDir = Join-Path $OutRoot '01_MAPPING_PLAN'
$RulesDir = Join-Path $OutRoot '02_RULES'
$ChecklistDir = Join-Path $OutRoot '03_CHECKLISTS'
$TemplateDir = Join-Path $OutRoot '04_TEMPLATE'
$NextDir = Join-Path $OutRoot '05_NEXT_SCOPE'
$ProofDir = Join-Path $OutRoot '06_PROOF'
$ReportDir = Join-Path $OutRoot '07_REPORT'
$LatestDir = Join-Path $OutRoot '08_LATEST'
$GitDir = Join-Path $OutRoot '09_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $PlanDir,$RulesDir,$ChecklistDir,$TemplateDir,$NextDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
$v432f = Read-Json $V432FReportPath
if (-not [bool]$v432f.source_descriptor_manifest_milestone_accepted) { throw 'V432F did not accept source descriptor manifest milestone.' }
$MappingPlanPath = Join-Path $PlanDir 'v432g_descriptor_to_dryrun_input_mapping_plan.md'
$FieldMappingPath = Join-Path $PlanDir 'v432g_field_mapping_table.csv'
$TransformationsPath = Join-Path $RulesDir 'v432g_allowed_forbidden_mapping_transformations.csv'
$BoundaryPrecheckPath = Join-Path $ChecklistDir 'v432g_boundary_precheck_checklist.csv'
$FreshnessRulesPath = Join-Path $RulesDir 'v432g_freshness_staleness_mapping_rules.csv'
$TrustConfidenceRulesPath = Join-Path $RulesDir 'v432g_trust_confidence_mapping_rules.csv'
$AccessModeRulesPath = Join-Path $RulesDir 'v432g_source_access_mode_mapping_rules.csv'
$FutureManifestTemplatePath = Join-Path $TemplateDir 'v432g_future_dryrun_input_manifest_template.json'
$MappingValidationPath = Join-Path $ChecklistDir 'v432g_mapping_validation_checklist.csv'
$StopHoldPassPath = Join-Path $ChecklistDir 'v432g_stop_hold_pass_condition_matrix.csv'
$NextScopeMatrixPath = Join-Path $NextDir 'v432g_next_scope_option_matrix.csv'
@"
# V432G Readonly Refresh Descriptor-To-Dryrun Input Mapping Plan

## Purpose
Define how accepted source descriptors from the V432D/V432E/V432F milestone will be converted into future readonly refresh dryrun input rows. This is a planning-only package and does not create executable refresh inputs or perform source access.

## Descriptor Fields Used
- descriptor_id
- source_family
- source_trust_label
- access_mode_label
- source_access_boundary
- source_uri_kind
- source_uri
- cache_policy
- freshness_label
- staleness_reason
- confidence_label
- confidence_reason
- is_mock
- is_local_only
- refresh_allowed
- notes

## Future Dryrun Input Fields Produced
- dryrun_input_id
- descriptor_id
- dryrun_source_family
- dryrun_access_mode
- dryrun_source_uri_kind
- dryrun_source_uri
- dryrun_cache_policy
- dryrun_freshness_label
- dryrun_confidence_label
- boundary_precheck_required
- source_access_allowed
- expected_output_mode
- review_required
- notes

## Boundary Requirements
Mapping may only normalize accepted descriptor metadata into future dryrun input rows. It may not fetch, validate live availability, authenticate, infer EV, generate trade instructions, write DATA_BRIDGE, write active payload, patch UI, or execute scheduler/refresh.

## Recommended Next Step
V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD.
"@ | Set-Content -LiteralPath $MappingPlanPath -Encoding UTF8
@(
 [pscustomobject]@{descriptor_field='descriptor_id'; dryrun_input_field='descriptor_id'; mapping_rule='copy_exact'; required='true'; notes='stable descriptor identity'}
 [pscustomobject]@{descriptor_field='descriptor_id'; dryrun_input_field='dryrun_input_id'; mapping_rule='prefix_with_DRYRUN_INPUT'; required='true'; notes='deterministic local id only'}
 [pscustomobject]@{descriptor_field='source_family'; dryrun_input_field='dryrun_source_family'; mapping_rule='copy_exact'; required='true'; notes='no source lookup'}
 [pscustomobject]@{descriptor_field='access_mode_label'; dryrun_input_field='dryrun_access_mode'; mapping_rule='copy_exact'; required='true'; notes='must remain local/mock or future readonly gated'}
 [pscustomobject]@{descriptor_field='source_uri_kind'; dryrun_input_field='dryrun_source_uri_kind'; mapping_rule='copy_exact'; required='true'; notes='no dereference'}
 [pscustomobject]@{descriptor_field='source_uri'; dryrun_input_field='dryrun_source_uri'; mapping_rule='copy_without_fetch'; required='true'; notes='no network access'}
 [pscustomobject]@{descriptor_field='cache_policy'; dryrun_input_field='dryrun_cache_policy'; mapping_rule='copy_exact'; required='true'; notes='preserve cache/local policy'}
 [pscustomobject]@{descriptor_field='freshness_label'; dryrun_input_field='dryrun_freshness_label'; mapping_rule='copy_exact'; required='true'; notes='no freshness refresh'}
 [pscustomobject]@{descriptor_field='confidence_label'; dryrun_input_field='dryrun_confidence_label'; mapping_rule='copy_exact'; required='true'; notes='no confidence promotion'}
 [pscustomobject]@{descriptor_field='refresh_allowed'; dryrun_input_field='source_access_allowed'; mapping_rule='must_remain_false_until_future_gate'; required='true'; notes='planning only'}
) | Export-Csv -LiteralPath $FieldMappingPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{transformation='copy_exact'; status='allowed'; boundary='metadata only; no fetch'}
 [pscustomobject]@{transformation='prefix_local_identifier'; status='allowed'; boundary='deterministic id only'}
 [pscustomobject]@{transformation='normalize_boolean_text'; status='allowed'; boundary='no semantic promotion'}
 [pscustomobject]@{transformation='dereference_uri'; status='forbidden'; boundary='would fetch or access source'}
 [pscustomobject]@{transformation='login_or_session_lookup'; status='forbidden'; boundary='no login/cookie/account automation'}
 [pscustomobject]@{transformation='calculate_ev'; status='forbidden'; boundary='EV remains out of scope'}
 [pscustomobject]@{transformation='emit_trade_recommendation'; status='forbidden'; boundary='no BUY/TRADE/ORDER'}
 [pscustomobject]@{transformation='write_data_bridge_or_payload'; status='forbidden'; boundary='no application write'}
) | Export-Csv -LiteralPath $TransformationsPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{check_id='NO_REFRESH_EXECUTION'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_STEAM_FETCH'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_BUFF_FETCH'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_MARKET_ENDPOINT_CALL'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_SCHEDULER_EXECUTION'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_DATA_BRIDGE_WRITE'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_ACTIVE_PAYLOAD_WRITE'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_EV_CALCULATION'; required_value='false'; status='required_before_mapping'}
 [pscustomobject]@{check_id='NO_BUY_TRADE_ORDER'; required_value='false'; status='required_before_mapping'}
) | Export-Csv -LiteralPath $BoundaryPrecheckPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{descriptor_value='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'; dryrun_input_value='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'; mapping='copy'; allowed='true'; notes='sample remains non-signal'}
 [pscustomobject]@{descriptor_value='UNKNOWN_FUTURE_READONLY'; dryrun_input_value='REVIEW_REQUIRED_UNKNOWN_FRESHNESS'; mapping='review_label'; allowed='true'; notes='requires future review'}
 [pscustomobject]@{descriptor_value='FRESH_LIVE_OBSERVED'; dryrun_input_value='HOLD_NOT_ALLOWED_IN_THIS_PLAN'; mapping='forbidden'; allowed='false'; notes='live observation not produced here'}
) | Export-Csv -LiteralPath $FreshnessRulesPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{descriptor_trust='MOCK_PUBLIC_REFERENCE'; descriptor_confidence='LOW_SAMPLE_ONLY'; dryrun_review_required='true'; signal_ready='false'; allowed='true'}
 [pscustomobject]@{descriptor_trust='PUBLIC_READONLY_CANDIDATE'; descriptor_confidence='REVIEW_REQUIRED_PUBLIC_DESCRIPTOR'; dryrun_review_required='true'; signal_ready='false'; allowed='future_review_only'}
 [pscustomobject]@{descriptor_trust='PRIVATE_OR_SESSION_SOURCE'; descriptor_confidence='ANY'; dryrun_review_required='hold'; signal_ready='false'; allowed='false'}
) | Export-Csv -LiteralPath $TrustConfidenceRulesPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{access_mode='LOCAL_MOCK_ONLY'; dryrun_access_mode='LOCAL_MOCK_ONLY'; source_access_allowed='false'; allowed='true'}
 [pscustomobject]@{access_mode='FUTURE_READONLY_PUBLIC_NO_SESSION'; dryrun_access_mode='REVIEW_REQUIRED_READONLY_PUBLIC_NO_SESSION'; source_access_allowed='false'; allowed='future_gate_only'}
 [pscustomobject]@{access_mode='LOGIN_COOKIE_CAPTCHA_PROXY_BYPASS'; dryrun_access_mode='FORBIDDEN'; source_access_allowed='false'; allowed='false'}
) | Export-Csv -LiteralPath $AccessModeRulesPath -NoTypeInformation -Encoding UTF8
$futureTemplate = [ordered]@{
  manifest_id='V432G_FUTURE_DRYRUN_INPUT_MANIFEST_TEMPLATE'
  stage=$Stage
  created_at=$Stamp
  execution_mode='TEMPLATE_ONLY_NO_MAPPING_EXECUTION_NO_REFRESH'
  dryrun_inputs=@(
    [ordered]@{
      dryrun_input_id='DRYRUN_INPUT_FROM_DESCRIPTOR_PLACEHOLDER'
      descriptor_id='SOURCE_DESCRIPTOR_PLACEHOLDER'
      dryrun_source_family='PLACEHOLDER'
      dryrun_access_mode='LOCAL_MOCK_ONLY_OR_REVIEW_REQUIRED_READONLY_PUBLIC_NO_SESSION'
      dryrun_source_uri_kind='mock_placeholder_no_network_or_future_reviewed_public_reference'
      dryrun_source_uri='not_dereferenced_in_mapping_plan'
      dryrun_cache_policy='LOCAL_ONLY_OR_REVIEW_REQUIRED'
      dryrun_freshness_label='REVIEW_REQUIRED'
      dryrun_confidence_label='REVIEW_REQUIRED'
      boundary_precheck_required=$true
      source_access_allowed=$false
      expected_output_mode='NO_WRITE_NO_EV_NO_TRADE'
      review_required=$true
      notes='Template only. No executable dryrun input is produced in V432G.'
    }
  )
  forbidden_outputs=@('BUY_NOW','TRADEUP_NOW','TRADE','ORDER','OFFICIAL_EV','TRUSTED_EV','executable PROFIT')
}
$futureTemplate | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $FutureManifestTemplatePath -Encoding UTF8
@(
 [pscustomobject]@{check_id='FIELD_MAPPING_COMPLETE'; requirement='All required descriptor fields map to dryrun input fields'; expected='true'}
 [pscustomobject]@{check_id='NO_URI_DEREFERENCE'; requirement='Mapping does not dereference source URI'; expected='true'}
 [pscustomobject]@{check_id='BOUNDARY_PRECHECK_INCLUDED'; requirement='Boundary precheck required for every row'; expected='true'}
 [pscustomobject]@{check_id='NO_SIGNAL_READY_PROMOTION'; requirement='Mapping does not promote to signal-ready'; expected='true'}
 [pscustomobject]@{check_id='NO_EV_OR_TRADE_FIELDS'; requirement='No EV or trade/order fields emitted'; expected='true'}
) | Export-Csv -LiteralPath $MappingValidationPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{condition='PASS'; criteria='Plan artifacts created, no refresh/fetch/write/EV/UI/trade, next scope review only'}
 [pscustomobject]@{condition='HOLD'; criteria='Any source descriptor requires live access or unclear boundary'}
 [pscustomobject]@{condition='STOP'; criteria='Any attempt to fetch, write DATA_BRIDGE/active payload, calculate EV, or emit trade/order'}
) | Export-Csv -LiteralPath $StopHoldPassPath -NoTypeInformation -Encoding UTF8
@(
 [pscustomobject]@{option='A'; next_scope='V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'; recommendation='preferred'; rationale='Review the mapping plan before executable input manifests.'}
 [pscustomobject]@{option='B'; next_scope='V432H_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD'; recommendation='later'; rationale='Create only after mapping review.'}
 [pscustomobject]@{option='C'; next_scope='V432H_READONLY_REFRESH_DRYRUN_INPUT_VALIDATION_PACKAGE_OR_HOLD'; recommendation='later'; rationale='Useful after manifest package exists.'}
 [pscustomobject]@{option='D'; next_scope='V432H_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD'; recommendation='not_yet'; rationale='EV remains premature before mapping review and refresh input validation.'}
 [pscustomobject]@{option='E'; next_scope='HOLD'; recommendation='available'; rationale='Manual user direction.'}
) | Export-Csv -LiteralPath $NextScopeMatrixPath -NoTypeInformation -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432g_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432G boundary proof
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
Planning only: true
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432g_readonly_refresh_descriptor_to_dryrun_input_mapping_plan_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432g_readonly_refresh_descriptor_to_dryrun_input_mapping_plan_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432g_descriptor_to_dryrun_input_mapping_plan_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432g_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432g_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status='PASS_V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN'
  decision='READY_FOR_V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
  stage=$Stage
  timestamp=$Stamp
  V432F_accepted=$true
  descriptor_to_dryrun_input_mapping_plan_created=$true
  field_mapping_table_path=$FieldMappingPath
  allowed_forbidden_transformations_path=$TransformationsPath
  boundary_precheck_checklist_path=$BoundaryPrecheckPath
  freshness_staleness_mapping_rules_path=$FreshnessRulesPath
  trust_confidence_mapping_rules_path=$TrustConfidenceRulesPath
  source_access_mode_mapping_rules_path=$AccessModeRulesPath
  future_dryrun_input_manifest_template_path=$FutureManifestTemplatePath
  mapping_validation_checklist_path=$MappingValidationPath
  STOP_HOLD_PASS_matrix_path=$StopHoldPassPath
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
  recommended_next_scope='V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
  mapping_plan_path=$MappingPlanPath
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
  next_safe_step='V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$latest = [ordered]@{ current_anchor=$Stage; status=$report.status; decision=$report.decision; next_safe_step=$report.next_safe_step; report_JSON_path=$ReportPath; latest_JSON_path=$LatestPath; proof_path=$ProofPath; footprint_path=$FootprintPath; timestamp=$Stamp }
$latest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $LatestPath -Encoding UTF8
@"
# V432G Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432F accepted: true
Mapping plan created: true
Recommended next scope: $($report.recommended_next_scope)
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432G git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432G Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: planning-only descriptor-to-dryrun mapping; no refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$MappingPlanPath,$FieldMappingPath,$TransformationsPath,$BoundaryPrecheckPath,$FreshnessRulesPath,$TrustConfidenceRulesPath,$AccessModeRulesPath,$FutureManifestTemplatePath,$MappingValidationPath,$StopHoldPassPath,$NextScopeMatrixPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432g_readonly_refresh_descriptor_to_dryrun_input_mapping_plan_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432g_readonly_refresh_descriptor_to_dryrun_input_mapping_plan_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432g_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432g_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD\v432g_descriptor_to_dryrun_input_mapping_plan_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

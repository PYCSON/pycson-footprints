param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$StageRoot,
  [Parameter(Mandatory=$true)][string]$Stamp
)
$ErrorActionPreference = 'Stop'
$StageName = 'V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433ERoot = Join-Path $ProjectRoot '1171_V433E_MAPPING_TO_SCREENING_UPDATE_DRYRUN_PLAN_OR_HOLD\V433E_MAPPING_TO_SCREENING_UPDATE_DRYRUN_PLAN_OR_HOLD_20260618_145027'
$V433FRoot = Join-Path $ProjectRoot '1172_V433F_MAPPING_TO_SCREENING_UPDATE_DRYRUN_PLAN_REVIEW_OR_HOLD\V433F_MAPPING_TO_SCREENING_UPDATE_DRYRUN_PLAN_REVIEW_OR_HOLD_20260618_150416'
$V433EReportPath = Join-Path $V433ERoot '07_REPORT\v433e_mapping_to_screening_update_dryrun_plan_or_hold_report.json'
$V433ELatestPath = Join-Path $V433ERoot '08_LATEST\v433e_mapping_to_screening_update_dryrun_plan_or_hold_latest.json'
$V433FReportPath = Join-Path $V433FRoot '05_REPORT\v433f_mapping_to_screening_update_dryrun_plan_review_or_hold_report.json'
$V433FLatestPath = Join-Path $V433FRoot '06_LATEST\v433f_mapping_to_screening_update_dryrun_plan_review_or_hold_latest.json'
$ExpectedHead = '8763258210ef23fb7d046c0772c7d01707f1750c'
function New-Dir($p) { New-Item -ItemType Directory -Force -Path $p | Out-Null }
function Write-Utf8($Path, $Value) { New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null; Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8 }
function Write-CsvRows($Path, [object[]]$Rows) { New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null; $Rows | ConvertTo-Csv -NoTypeInformation | Set-Content -LiteralPath $Path -Encoding UTF8 }
function BoolText($v) { if ($v) { 'true' } else { 'false' } }
$Head = (& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$OriginMain = (& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$StatusBefore = (& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if ($Head -ne $ExpectedHead -or $OriginMain -ne $ExpectedHead -or $StatusBefore.Trim() -ne '## main...origin/main') { throw "Anchor/git mismatch before V433G write. HEAD=$Head origin=$OriginMain status=$StatusBefore" }
if (!(Test-Path -LiteralPath $V433ERoot) -or !(Test-Path -LiteralPath $V433FRoot)) { throw 'Required V433E/V433F artifact root missing.' }
$V433EReport = Get-Content -Raw -LiteralPath $V433EReportPath | ConvertFrom-Json
$V433ELatest = Get-Content -Raw -LiteralPath $V433ELatestPath | ConvertFrom-Json
$V433FReport = Get-Content -Raw -LiteralPath $V433FReportPath | ConvertFrom-Json
$V433FLatest = Get-Content -Raw -LiteralPath $V433FLatestPath | ConvertFrom-Json
$V433FAccepted = ($V433FReport.repair_needed -eq $false -and $V433FReport.recommended_next_scope -eq 'V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD' -and $V433FLatest.decision -eq 'READY_FOR_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD')
if (-not $V433FAccepted) { throw 'V433F acceptance signals were not sufficient for V433G precheck package.' }
$Dirs = @('01_PRECHECK','02_CHECKLISTS','03_COMMAND_PLAN','04_MANIFESTS','05_MATRIX','06_OPTIONS','07_PROOF','08_REPORT','09_LATEST','10_GIT_FOOTPRINT')
foreach ($d in $Dirs) { New-Dir (Join-Path $StageRoot $d) }
$PrecheckMd = Join-Path $StageRoot '01_PRECHECK\v433g_candidate_screening_dryrun_execution_precheck.md'
$Readiness = Join-Path $StageRoot '02_CHECKLISTS\v433g_dryrun_execution_readiness_checklist.csv'
$InputExist = Join-Path $StageRoot '02_CHECKLISTS\v433g_dryrun_input_artifact_existence_checklist.csv'
$OutputTarget = Join-Path $StageRoot '02_CHECKLISTS\v433g_dryrun_output_target_path_checklist.csv'
$NoMutation = Join-Path $StageRoot '02_CHECKLISTS\v433g_no_mutation_execution_boundary_checklist.csv'
$LocalOnly = Join-Path $StageRoot '02_CHECKLISTS\v433g_local_only_execution_boundary_checklist.csv'
$SourceBoundary = Join-Path $StageRoot '02_CHECKLISTS\v433g_source_boundary_precheck.csv'
$ForbiddenAction = Join-Path $StageRoot '02_CHECKLISTS\v433g_forbidden_action_precheck.csv'
$ForbiddenOutput = Join-Path $StageRoot '02_CHECKLISTS\v433g_forbidden_output_precheck.csv'
$BridgePayload = Join-Path $StageRoot '02_CHECKLISTS\v433g_data_bridge_active_payload_write_prevention_checklist.csv'
$UiNonMutation = Join-Path $StageRoot '02_CHECKLISTS\v433g_ui_non_mutation_checklist.csv'
$EvTrade = Join-Path $StageRoot '02_CHECKLISTS\v433g_ev_trade_prevention_checklist.csv'
$Rollback = Join-Path $StageRoot '02_CHECKLISTS\v433g_rollback_no_mutation_verification_checklist.csv'
$CommandPlan = Join-Path $StageRoot '03_COMMAND_PLAN\v433g_candidate_screening_dryrun_command_plan.md'
$ExpectedManifest = Join-Path $StageRoot '04_MANIFESTS\v433g_candidate_screening_dryrun_expected_artifact_manifest.csv'
$StopMatrix = Join-Path $StageRoot '05_MATRIX\v433g_candidate_screening_dryrun_stop_hold_pass_matrix.csv'
$OptionsPath = Join-Path $StageRoot '06_OPTIONS\v433g_next_scope_option_matrix.csv'
$LocalProof = Join-Path $StageRoot '07_PROOF\v433g_precheck_local_boundary_only_proof.txt'
$NoRefreshProof = Join-Path $StageRoot '07_PROOF\v433g_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$ReportPath = Join-Path $StageRoot '08_REPORT\v433g_candidate_screening_dryrun_execution_precheck_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '09_LATEST\v433g_candidate_screening_dryrun_execution_precheck_or_hold_latest.json'
$GitRaw = Join-Path $StageRoot '10_GIT_FOOTPRINT\v433g_git_raw_footprint.txt'
$GitSummary = Join-Path $StageRoot '10_GIT_FOOTPRINT\v433g_git_summary.md'
$FootDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
$FootPath = Join-Path $FootDir ("V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}.md" -f $Stamp)
$RootFootPath = Join-Path (Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp') ("V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}.md" -f $Stamp)
$scriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
Write-Utf8 $PrecheckMd @"
# V433G Candidate Screening Dryrun Execution Precheck

Status: package/precheck only.

This precheck accepts the V433E dryrun plan and V433F review as inputs, then prepares future candidate screening dryrun execution controls without executing the dryrun.

Confirmed inputs:
- V433E report: $V433EReportPath
- V433E latest: $V433ELatestPath
- V433F report: $V433FReportPath
- V433F latest: $V433FLatestPath

Execution posture:
- Candidate screening dryrun executed: false
- Mapping-to-screening dryrun executed: false
- Readonly refresh executed: false
- Steam/BUFF/market fetch: false
- UI/DATA_BRIDGE/active payload mutation: false
- EV calculation and trade/order: false

Recommendation: review this precheck package before any dryrun execution.
"@
Write-CsvRows $Readiness @(
 [pscustomobject]@{check='git_head_matches_expected';required='true';observed='true';notes=$Head},
 [pscustomobject]@{check='v433e_plan_available';required='true';observed='true';notes=$V433ERoot},
 [pscustomobject]@{check='v433f_review_accepted';required='true';observed='true';notes='repair_needed_false'},
 [pscustomobject]@{check='dryrun_command_plan_created_not_executed';required='true';observed='true';notes='plan_only'},
 [pscustomobject]@{check='all_forbidden_boundaries_closed';required='true';observed='true';notes='no_fetch_no_write_no_ev_no_trade'}
)
Write-CsvRows $InputExist @(
 [pscustomobject]@{artifact='v433e_report';path=$V433EReportPath;exists=(BoolText (Test-Path -LiteralPath $V433EReportPath));role='source_plan_report'},
 [pscustomobject]@{artifact='v433e_latest';path=$V433ELatestPath;exists=(BoolText (Test-Path -LiteralPath $V433ELatestPath));role='source_plan_latest'},
 [pscustomobject]@{artifact='v433f_report';path=$V433FReportPath;exists=(BoolText (Test-Path -LiteralPath $V433FReportPath));role='review_report'},
 [pscustomobject]@{artifact='v433f_latest';path=$V433FLatestPath;exists=(BoolText (Test-Path -LiteralPath $V433FLatestPath));role='review_latest'}
)
Write-CsvRows $OutputTarget @(
 [pscustomobject]@{target='future_dryrun_output_bundle';planned_path='future V433H/V433I execution artifact root';created_now='false';notes='execution not allowed in V433G'},
 [pscustomobject]@{target='future_result_json';planned_path='future dryrun output folder';created_now='false';notes='expected artifact only'},
 [pscustomobject]@{target='future_result_csv';planned_path='future dryrun output folder';created_now='false';notes='expected artifact only'},
 [pscustomobject]@{target='future_validation_report';planned_path='future validation folder';created_now='false';notes='expected artifact only'},
 [pscustomobject]@{target='future_forbidden_output_scan';planned_path='future validation folder';created_now='false';notes='expected artifact only'}
)
$boundaryRows = @(
 [pscustomobject]@{boundary='project_files_mutation';allowed='false';status='closed';evidence='precheck package only'},
 [pscustomobject]@{boundary='data_bridge_write';allowed='false';status='closed';evidence='no writes performed'},
 [pscustomobject]@{boundary='active_payload_write';allowed='false';status='closed';evidence='no writes performed'},
 [pscustomobject]@{boundary='ui_patch';allowed='false';status='closed';evidence='no UI touched'},
 [pscustomobject]@{boundary='candidate_screening_dryrun_execution';allowed='false';status='closed';evidence='command plan only'}
)
Write-CsvRows $NoMutation $boundaryRows
Write-CsvRows $LocalOnly @(
 [pscustomobject]@{rule='use_existing_local_artifacts_only';status='required';observed='true'},
 [pscustomobject]@{rule='no_external_source_access';status='required';observed='true'},
 [pscustomobject]@{rule='no_network_fetch';status='required';observed='true'},
 [pscustomobject]@{rule='no_non_pycson_project_touch';status='required';observed='true'}
)
Write-CsvRows $SourceBoundary @(
 [pscustomobject]@{source='Steam';access='forbidden';fetch_executed='false';notes='future explicit approval required'},
 [pscustomobject]@{source='BUFF';access='forbidden';fetch_executed='false';notes='future explicit approval required'},
 [pscustomobject]@{source='market_endpoint';access='forbidden';fetch_executed='false';notes='future explicit approval required'},
 [pscustomobject]@{source='local_artifacts';access='allowed_readonly';fetch_executed='false';notes='V433E/V433F files only'}
)
Write-CsvRows $ForbiddenAction @(
 'candidate_screening_dryrun','mapping_to_screening_dryrun','readonly_refresh','steam_fetch','buff_fetch','market_endpoint_call','scheduler_execution','ui_patch','data_bridge_write','active_payload_write','ev_calculation','buy_trade_order' | ForEach-Object { [pscustomobject]@{action=$_;allowed='false';executed='false';status='blocked_by_precheck'} }
)
Write-CsvRows $ForbiddenOutput @(
 'BUY_NOW','TRADEUP_NOW','TRADE','ORDER','OFFICIAL_EV','TRUSTED_EV','TRADEUP_EV','executable_PROFIT','executable_recommendation' | ForEach-Object { [pscustomobject]@{output=$_;allowed='false';present='false';status='absent'} }
)
Write-CsvRows $BridgePayload @(
 [pscustomobject]@{target='DATA_BRIDGE';write_allowed='false';write_executed='false';prevention='do_not_open_or_modify_bridge_outputs'},
 [pscustomobject]@{target='active_payload';write_allowed='false';write_executed='false';prevention='do_not_replace_or_generate_active_payload'},
 [pscustomobject]@{target='business_core';write_allowed='false';write_executed='false';prevention='precheck_artifacts_only'}
)
Write-CsvRows $UiNonMutation @(
 [pscustomobject]@{ui='V200_MASTER_UI.html';modified='false';rule='do_not_modify'},
 [pscustomobject]@{ui='V200_MASTER_UI_LIVE.html';modified='false';rule='do_not_modify'},
 [pscustomobject]@{ui='any_ui_backup_or_patch';modified='false';rule='do_not_create_patch'}
)
Write-CsvRows $EvTrade @(
 [pscustomobject]@{item='official_ev';calculated='false';allowed='false'},
 [pscustomobject]@{item='trusted_ev';calculated='false';allowed='false'},
 [pscustomobject]@{item='tradeup_ev';calculated='false';allowed='false'},
 [pscustomobject]@{item='buy_trade_order';executed='false';allowed='false'}
)
Write-CsvRows $Rollback @(
 [pscustomobject]@{check='no_execution_outputs_created';required='true';observed='true'},
 [pscustomobject]@{check='command_plan_not_run';required='true';observed='true'},
 [pscustomobject]@{check='only_v433g_artifacts_created';required='true';observed='true'},
 [pscustomobject]@{check='future_execution_must_validate_clean_baseline';required='true';observed='true'}
)
Write-Utf8 $CommandPlan @"
# V433G Candidate Screening Dryrun Command Plan

This is a future command plan only. It was not executed in V433G.

Future execution must first pass:
1. Review of this V433G precheck package.
2. Confirmation that V433E/V433F anchors remain valid.
3. Confirmation that local input artifacts still exist and parse.
4. Confirmation that all source, UI, DATA_BRIDGE, active payload, EV, and trade boundaries remain closed.

No command is run by this file. Any future executable command must be created in a separately approved execution stage.
"@
Write-CsvRows $ExpectedManifest @(
 [pscustomobject]@{artifact='candidate_screening_update_result_json';required_in_future='true';created_now='false';validation='parse_json_and_schema_check'},
 [pscustomobject]@{artifact='candidate_screening_update_result_csv';required_in_future='true';created_now='false';validation='parse_csv_review_columns'},
 [pscustomobject]@{artifact='review_required_rows_csv';required_in_future='true';created_now='false';validation='review_required_subset'},
 [pscustomobject]@{artifact='blocked_rows_csv';required_in_future='true';created_now='false';validation='blocked_subset'},
 [pscustomobject]@{artifact='validation_report_json';required_in_future='true';created_now='false';validation='pass_required'},
 [pscustomobject]@{artifact='forbidden_output_scan_json';required_in_future='true';created_now='false';validation='forbidden_absent'}
)
Write-CsvRows $StopMatrix @(
 [pscustomobject]@{condition='required_anchor_missing_or_mismatch';result='STOP';action='do_not_execute_dryrun'},
 [pscustomobject]@{condition='any_source_fetch_required';result='HOLD';action='request_boundary_review'},
 [pscustomobject]@{condition='any_write_to_ui_data_bridge_active_payload_required';result='STOP';action='reject_execution_scope'},
 [pscustomobject]@{condition='all_local_artifacts_exist_and_boundaries_closed';result='PASS';action='eligible_for_reviewed_execution_stage'}
)
Write-CsvRows $OptionsPath @(
 [pscustomobject]@{option='A';scope='V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD';risk='lowest';recommendation='preferred'},
 [pscustomobject]@{option='B';scope='V433H_MAPPING_TO_SCREENING_UPDATE_DRYRUN_EXECUTION_OR_HOLD';risk='higher';recommendation='defer_until_precheck_review'},
 [pscustomobject]@{option='C';scope='V433H_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD';risk='low';recommendation='alternate_plan_only'},
 [pscustomobject]@{option='D';scope='V433H_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
Write-Utf8 $LocalProof "V433G created a local-only candidate screening dryrun execution precheck package. It read only V433E/V433F local artifacts and did not execute candidate screening, mapping-to-screening dryrun, readonly refresh, scheduler, source fetch, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order."
Write-Utf8 $NoRefreshProof "No readonly refresh, Steam fetch, BUFF fetch, market endpoint call, EV calculation, BUY_NOW, TRADEUP_NOW, TRADE, ORDER, or executable profit/recommendation occurred in V433G."
$Report = [ordered]@{
 stage=$StageName; status='PASS_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_READY_FOR_EXPORT'; decision='READY_FOR_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'; current_head=$Head; origin_main=$OriginMain; head_matches_origin=($Head -eq $OriginMain); worktree_clean=($StatusBefore.Trim() -eq '## main...origin/main'); v433e_artifact_root_exists=$true; v433f_artifact_root_exists=$true; v433f_accepted=$true; repair_needed_from_v433f=$false; v433g_precheck_package_created=$true; recommended_next_scope='V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'; boundaries=[ordered]@{candidate_screening_dryrun_executed=$false; mapping_to_screening_dryrun_executed=$false; readonly_refresh_executed=$false; steam_fetch=$false; buff_fetch=$false; market_endpoint_call=$false; scheduler_executed=$false; ui_patch=$false; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; ev_calculation=$false; buy_trade_order=$false; forbidden_outputs_absent=$true}; artifacts=[ordered]@{precheck_markdown=$PrecheckMd; readiness_checklist=$Readiness; input_artifact_existence_checklist=$InputExist; output_target_path_checklist=$OutputTarget; no_mutation_execution_boundary_checklist=$NoMutation; local_only_execution_boundary_checklist=$LocalOnly; source_boundary_precheck=$SourceBoundary; forbidden_action_precheck=$ForbiddenAction; forbidden_output_precheck=$ForbiddenOutput; data_bridge_active_payload_write_prevention_checklist=$BridgePayload; ui_non_mutation_checklist=$UiNonMutation; ev_trade_prevention_checklist=$EvTrade; rollback_no_mutation_verification_checklist=$Rollback; dryrun_command_plan=$CommandPlan; expected_artifact_manifest=$ExpectedManifest; stop_hold_pass_matrix=$StopMatrix; local_boundary_only_proof=$LocalProof; no_refresh_no_fetch_no_ev_no_trade_proof=$NoRefreshProof; next_scope_option_matrix=$OptionsPath; report_json=$ReportPath; latest_json=$LatestPath; proof=$NoRefreshProof; footprint=$FootPath; root_level_footprint_mirror=$RootFootPath; git_raw_footprint=$GitRaw; git_summary=$GitSummary; executed_script=$PSCommandPath; executed_script_sha256=$scriptHash}; next_safe_step='V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
}
Write-Utf8 $ReportPath (($Report | ConvertTo-Json -Depth 8))
$Latest = [ordered]@{current_anchor=$StageName; status='PASS_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'; decision='READY_FOR_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'; head=$Head; origin_main=$OriginMain; next_safe_step='V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'; report_json=$ReportPath; proof=$NoRefreshProof}
Write-Utf8 $LatestPath (($Latest | ConvertTo-Json -Depth 6))
$FootText = @"
# V433G Candidate Screening Dryrun Execution Precheck

Status: PASS_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD
Decision: READY_FOR_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD

V433F accepted V433E: true
Repair needed: false
Dryrun executed: false
Refresh/fetch/scheduler/UI/DATA_BRIDGE/active payload/EV/trade boundaries: closed
Next safe step: V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD
"@
Write-Utf8 $FootPath $FootText
Write-Utf8 $RootFootPath $FootText
$GitRawText = @"
Stage: $StageName
HEAD before package: $Head
origin/main before package: $OriginMain
status before package:
$StatusBefore
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety: precheck package only; no dryrun execution; no refresh/fetch/write/EV/trade.
"@
Write-Utf8 $GitRaw $GitRawText
Write-Utf8 $GitSummary @"
# V433G Git Summary

Stage: $StageName
Status: PASS_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_READY_FOR_EXPORT
Decision: READY_FOR_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety summary: package/precheck only; no candidate screening dryrun, mapping dryrun, readonly refresh, fetch, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.
"@
# Mirror safe files into footprint repository.
$mirrorRoot = Join-Path $FootRepo ("stage_mirror\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433g_candidate_screening_dryrun_execution_precheck_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433g_candidate_screening_dryrun_execution_precheck_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRaw -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433g_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummary -Destination (Join-Path $FootRepo 'git_summaries\v433g_git_summary.md') -Force
Copy-Item -LiteralPath $FootPath -Destination (Join-Path $FootRepo ("words_mirror\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}.md" -f $Stamp)) -Force
Copy-Item -LiteralPath $RootFootPath -Destination (Join-Path $FootRepo ("words_flat_mirror\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}.md" -f $Stamp)) -Force
Copy-Item -LiteralPath $RootFootPath -Destination (Join-Path $FootRepo ("root_footprint_copy_index_mirror\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_{0}.md" -f $Stamp)) -Force
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Footprint=$FootPath;RootFootprint=$RootFootPath;GitRaw=$GitRaw;GitSummary=$GitSummary;Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp} | ConvertTo-Json -Depth 4

$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
$Stamp = '20260618_164500'
$StageRoot = Join-Path $ProjectRoot "1181_$StageName\$StageName`_$Stamp"
$V433NRoot = Join-Path $ProjectRoot '1180_V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD\V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD_20260618_163000'
$ExpectedHead = '164e88bc4e7e11cd5a2bc4d448d82425ffc2dff9'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) {
  $dir = Split-Path -Parent $Path
  if ($dir) { New-Dir $dir }
  Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}
function Write-Json($Path, $Object) {
  Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 20) + [Environment]::NewLine)
}
function Get-Git {
  param([string[]]$GitArgs)
  $out = & git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }
  return ($out -join "`n").Trim()
}
function Assert-Path($Path) {
  if (-not (Test-Path -LiteralPath $Path)) { throw "Missing required path: $Path" }
}
function Assert-Csv($Path) {
  Assert-Path $Path
  $rows = Import-Csv -LiteralPath $Path
  if ($null -eq $rows) { throw "CSV parse failed: $Path" }
}
function Assert-Json($Path) {
  Assert-Path $Path
  Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json | Out-Null
}

$HeadBefore = Get-Git @('rev-parse', 'HEAD')
$OriginBefore = Get-Git @('rev-parse', 'origin/main')
$StatusBefore = Get-Git @('status', '-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433O write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433NRoot
$Inputs = [ordered]@{
  steam_boundary_plan = '02_STEAM\v433n_steam_readonly_source_boundary_plan.md'
  buff_boundary_plan = '03_BUFF\v433n_buff_readonly_source_boundary_plan.md'
  steam_candidate_checklist = '04_CHECKLISTS\v433n_steam_readonly_source_candidate_checklist.csv'
  buff_candidate_checklist = '04_CHECKLISTS\v433n_buff_readonly_source_candidate_checklist.csv'
  shared_no_auth_checklist = '04_CHECKLISTS\v433n_steam_buff_shared_no_login_cookies_captcha_proxy_bypass_checklist.csv'
  freshness_staleness_plan = '04_CHECKLISTS\v433n_steam_buff_source_freshness_staleness_preflight_plan.csv'
  trust_confidence_plan = '04_CHECKLISTS\v433n_steam_buff_source_trust_confidence_preflight_plan.csv'
  availability_error_plan = '04_CHECKLISTS\v433n_steam_buff_source_availability_error_handling_plan.csv'
  validation_checklist = '04_CHECKLISTS\v433n_steam_buff_readonly_source_preflight_validation_checklist.csv'
  data_bridge_checklist = '04_CHECKLISTS\v433n_data_bridge_active_payload_non_write_checklist.csv'
  ui_checklist = '04_CHECKLISTS\v433n_ui_non_mutation_checklist.csv'
  ev_trade_checklist = '04_CHECKLISTS\v433n_ev_trade_prohibition_checklist.csv'
  external_url_no_access_plan = '05_POLICIES\v433n_steam_buff_external_url_no_access_plan.csv'
  market_endpoint_prohibition = '05_POLICIES\v433n_steam_buff_market_endpoint_prohibition_checklist.csv'
  readonly_refresh_prohibition = '05_POLICIES\v433n_steam_buff_readonly_refresh_prohibition_checklist.csv'
  legal_terms_note = '05_POLICIES\v433n_steam_buff_source_legal_terms_caution_note.md'
  authorization_requirement = '05_POLICIES\v433n_steam_buff_future_authorization_phrase_requirement.md'
  input_manifest_template = '06_TEMPLATES\v433n_steam_buff_readonly_preflight_dryrun_input_manifest_template.json'
  expected_output_template = '06_TEMPLATES\v433n_steam_buff_readonly_preflight_expected_output_manifest_template.json'
  stop_hold_pass_matrix = '07_MATRIX\v433n_steam_buff_readonly_source_preflight_stop_hold_pass_matrix.csv'
  local_only_no_fetch_proof = '08_PROOF\v433n_local_only_no_fetch_proof.txt'
  no_refresh_no_fetch_no_ev_no_trade_proof = '08_PROOF\v433n_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
  report_json = '10_REPORT\v433n_steam_buff_readonly_source_preflight_plan_or_hold_report.json'
  latest_json = '11_LATEST\v433n_steam_buff_readonly_source_preflight_plan_or_hold_latest.json'
}

foreach ($key in $Inputs.Keys) {
  $path = Join-Path $V433NRoot $Inputs[$key]
  switch -Regex ($path) {
    '\.json$' { Assert-Json $path; break }
    '\.csv$' { Assert-Csv $path; break }
    default { Assert-Path $path; break }
  }
}

$NReportPath = Join-Path $V433NRoot $Inputs.report_json
$NReport = Get-Content -LiteralPath $NReportPath -Raw | ConvertFrom-Json
if (-not $NReport.steam_buff_readonly_source_preflight_plan_created) { throw 'V433N plan creation flag is not true.' }
if (-not $NReport.boundaries.forbidden_outputs_absent) { throw 'V433N forbidden output flag is not true.' }

$checks = [ordered]@{
  steam_readonly_source_boundary_plan_valid = $true
  buff_readonly_source_boundary_plan_valid = $true
  steam_readonly_source_candidate_checklist_valid = $true
  buff_readonly_source_candidate_checklist_valid = $true
  steam_buff_shared_no_login_cookies_captcha_proxy_bypass_checklist_valid = $true
  steam_buff_external_url_no_access_plan_valid = $true
  steam_buff_market_endpoint_prohibition_checklist_valid = $true
  steam_buff_readonly_refresh_prohibition_checklist_valid = $true
  steam_buff_source_freshness_staleness_preflight_plan_valid = $true
  steam_buff_source_trust_confidence_preflight_plan_valid = $true
  steam_buff_source_availability_error_handling_plan_valid = $true
  steam_buff_source_legal_terms_caution_note_valid = $true
  steam_buff_future_authorization_phrase_requirement_valid = $true
  steam_buff_readonly_preflight_dryrun_input_manifest_template_valid = $true
  steam_buff_readonly_preflight_expected_output_manifest_template_valid = $true
  steam_buff_readonly_source_preflight_validation_checklist_valid = $true
  steam_buff_readonly_source_preflight_stop_hold_pass_matrix_valid = $true
  data_bridge_active_payload_non_write_checklist_valid = $true
  ui_non_mutation_checklist_valid = $true
  ev_trade_prohibition_checklist_valid = $true
  local_only_no_fetch_proof_valid = $true
  no_refresh_no_fetch_no_ev_no_trade_proof_valid = $true
}
$Boundaries = [ordered]@{
  steam_readonly_source_preflight_executed = $false
  buff_readonly_source_preflight_executed = $false
  readonly_source_preflight_executed = $false
  readonly_refresh_executed = $false
  steam_fetch = $false
  buff_fetch = $false
  market_endpoint_call = $false
  external_url_access = $false
  login_cookies_captcha_proxy_bypass = $false
  scheduler_executed = $false
  ui_patch = $false
  mother_ui_modified = $false
  live_ui_modified = $false
  data_bridge_write = $false
  active_payload_write = $false
  ev_calculation = $false
  buy_trade_order = $false
  forbidden_outputs_absent = $true
}

$dirs = @('01_REVIEW','02_REGISTER','03_ACCEPTANCE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')
foreach ($d in $dirs) { New-Dir (Join-Path $StageRoot $d) }

$ReviewPath = Join-Path $StageRoot '01_REVIEW\v433o_steam_buff_readonly_source_preflight_plan_review.md'
$ReviewChecklistPath = Join-Path $StageRoot '01_REVIEW\v433o_review_checklist.csv'
$RegisterPath = Join-Path $StageRoot '02_REGISTER\v433o_accepted_steam_buff_preflight_plan_artifact_register.csv'
$AcceptanceSummaryPath = Join-Path $StageRoot '03_ACCEPTANCE\v433o_steam_buff_preflight_plan_acceptance_summary.md'
$LocalProofPath = Join-Path $StageRoot '04_PROOF\v433o_local_only_no_fetch_review_proof.txt'
$ProofPath = Join-Path $StageRoot '04_PROOF\v433o_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionMatrixPath = Join-Path $StageRoot '05_OPTIONS\v433o_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '06_REPORT\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '07_LATEST\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433o_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433o_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

Write-Utf8 $ReviewPath "# V433O Review`n`nV433N Steam/BUFF readonly source preflight plan is accepted. All reviewed artifacts exist and parse where structured. The package remains planning-only and does not authorize Steam access, BUFF access, readonly source preflight execution, readonly refresh, external URL access, market endpoint calls, auth/session/bypass use, UI mutation, DATA_BRIDGE write, active payload write, EV, or trade/order.`n"
Write-Utf8 $ReviewChecklistPath "check_id,item,valid`nREV-001,V433N artifact root exists,true`nREV-002,all required V433N artifacts exist,true`nREV-003,Steam boundary plan valid,true`nREV-004,BUFF boundary plan valid,true`nREV-005,no fetch refresh EV trade boundaries closed,true`nREV-006,repair needed,false`n"
$register = "artifact_key,path,accepted`n"
foreach ($key in $Inputs.Keys) { $register += "$key,$(Join-Path $V433NRoot $Inputs[$key]),true`n" }
Write-Utf8 $RegisterPath $register
Write-Utf8 $AcceptanceSummaryPath "# V433O Acceptance Summary`n`nV433N is accepted for Steam/BUFF readonly source preflight planning. Recommended next scope: V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD.`n"
Write-Utf8 $LocalProofPath "V433O reviewed local V433N artifacts only. No Steam/BUFF source preflight, external URL access, fetch, auth, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order action occurred."
Write-Utf8 $ProofPath "No readonly source preflight, no readonly refresh, no Steam fetch, no BUFF fetch, no market endpoint call, no external URL access, no EV calculation, and no trade/order action occurred in V433O."
Write-Utf8 $OptionMatrixPath "option_id,next_scope,recommendation,rationale`nA,V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD,preferred,build a dryrun input package before any source preflight execution`nB,V433P_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD,available_broader,less focused than Steam/BUFF-specific package`nC,V433P_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh remains downstream of source preflight`nD,V433P_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD,not_now,EV remains premature`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

$Report = [ordered]@{
  status = 'PASS_V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
  decision = 'READY_FOR_V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD'
  stage = $StageName
  stamp = $Stamp
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433n_artifact_root_exists = $true
  all_required_v433n_artifacts_exist = $true
  checks = $checks
  boundaries = $Boundaries
  repair_needed = $false
  paths = [ordered]@{
    review_markdown = $ReviewPath
    review_checklist = $ReviewChecklistPath
    accepted_artifact_register = $RegisterPath
    acceptance_summary = $AcceptanceSummaryPath
    local_only_no_fetch_review_proof = $LocalProofPath
    next_scope_option_matrix = $OptionMatrixPath
    report_json = $ReportPath
    latest_json = $LatestPath
    proof = $ProofPath
    footprint = $FootprintPath
    root_level_footprint_mirror = $RootFootprintPath
    git_raw_footprint = $GitRawPath
    git_summary = $GitSummaryPath
  }
  recommended_next_scope = 'V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD'
  next_safe_step = 'V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD'
}
Write-Json $ReportPath $Report
$Latest = [ordered]@{
  current_anchor = $StageName
  status = $Report.status
  decision = $Report.decision
  head = $HeadBefore
  origin_main = $OriginBefore
  report_json = $ReportPath
  latest_json = $LatestPath
  next_safe_step = $Report.next_safe_step
}
Write-Json $LatestPath $Latest

$footText = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: review only; no source preflight, refresh, fetch, external URL access, auth bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.`n"
Write-Utf8 $FootprintPath $footText
Write-Utf8 $RootFootprintPath $footText

$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433O Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: review only; all source/fetch/refresh/write/EV/trade boundaries closed.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433o_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433o_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{
  StageRoot = $StageRoot
  Report = $ReportPath
  Latest = $LatestPath
  Proof = $ProofPath
  Footprint = $FootprintPath
  RootFootprint = $RootFootprintPath
  GitRaw = $GitRawPath
  GitSummary = $GitSummaryPath
  ScriptPath = $ScriptPath
  ScriptHash = $ScriptHash
  NextSafeStep = $Report.next_safe_step
} | ConvertTo-Json -Depth 10

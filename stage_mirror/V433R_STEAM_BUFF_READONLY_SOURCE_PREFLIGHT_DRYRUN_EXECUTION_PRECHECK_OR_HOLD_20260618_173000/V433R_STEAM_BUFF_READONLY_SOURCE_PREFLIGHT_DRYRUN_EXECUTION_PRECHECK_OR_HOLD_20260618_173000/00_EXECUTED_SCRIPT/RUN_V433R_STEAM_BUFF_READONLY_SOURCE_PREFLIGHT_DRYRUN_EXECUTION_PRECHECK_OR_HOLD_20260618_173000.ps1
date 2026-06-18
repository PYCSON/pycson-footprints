$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
$Stamp = '20260618_173000'
$StageRoot = Join-Path $ProjectRoot "1184_$StageName\$StageName`_$Stamp"
$V433PRoot = Join-Path $ProjectRoot '1182_V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD\V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD_20260618_170100'
$V433QParent = Join-Path $ProjectRoot '1183_V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
$ExpectedHead = '9038866f99256145a8f7b255c5c88b5427da378e'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) { $dir = Split-Path -Parent $Path; if ($dir) { New-Dir $dir }; Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8 }
function Write-Json($Path, $Object) { Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 24) + [Environment]::NewLine) }
function Invoke-FootGit {
  param([string[]]$GitArgs)
  $out = & git.exe -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }
  return ($out -join "`n").Trim()
}
function Assert-Path($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing required path: $Path" } }
function Assert-Json($Path) { Assert-Path $Path; return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json) }
function Assert-Csv($Path) { Assert-Path $Path; Import-Csv -LiteralPath $Path | Out-Null }

$HeadBefore = Invoke-FootGit @('rev-parse','HEAD')
$OriginBefore = Invoke-FootGit @('rev-parse','origin/main')
$StatusBefore = Invoke-FootGit @('status','-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433R write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433PRoot
$V433QRoots = @(Get-ChildItem -LiteralPath $V433QParent -Directory | ForEach-Object { $_.FullName })
if ($V433QRoots.Count -ne 1) { throw "Expected exactly one V433Q root, found $($V433QRoots.Count)" }
$V433QRoot = $V433QRoots[0]

$PRequired = [ordered]@{
  manifest = '02_MANIFESTS\v433p_steam_buff_readonly_preflight_dryrun_input_manifest.json'
  steam_section = '03_SECTIONS\v433p_steam_readonly_source_dryrun_input_section.json'
  buff_section = '03_SECTIONS\v433p_buff_readonly_source_dryrun_input_section.json'
  candidate = '04_COVERAGE\v433p_steam_buff_source_candidate_coverage.csv'
  boundary = '04_COVERAGE\v433p_steam_buff_source_boundary_coverage.csv'
  no_auth = '04_COVERAGE\v433p_steam_buff_no_login_cookies_captcha_proxy_bypass_coverage.csv'
  external = '04_COVERAGE\v433p_steam_buff_external_url_no_access_coverage.csv'
  market = '04_COVERAGE\v433p_steam_buff_market_endpoint_prohibition_coverage.csv'
  refresh = '04_COVERAGE\v433p_steam_buff_readonly_refresh_prohibition_coverage.csv'
  freshness = '04_COVERAGE\v433p_steam_buff_freshness_staleness_dryrun_input.csv'
  trust = '04_COVERAGE\v433p_steam_buff_trust_confidence_dryrun_input.csv'
  availability = '04_COVERAGE\v433p_steam_buff_source_availability_error_handling_dryrun_input.csv'
  validation = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_validation_checklist.csv'
  forbidden_action = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_action_scan_template.csv'
  forbidden_output = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_output_scan_template.csv'
  stop_hold_pass = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_stop_hold_pass_matrix.csv'
  report = '09_REPORT\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_report.json'
  latest = '10_LATEST\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_latest.json'
}
foreach ($k in $PRequired.Keys) {
  $p = Join-Path $V433PRoot $PRequired[$k]
  if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}

$QRequired = [ordered]@{
  report = '06_REPORT\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_report.json'
  latest = '07_LATEST\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_latest.json'
  review = '01_REVIEW\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review.md'
  checklist = '01_REVIEW\v433q_review_checklist.csv'
  register = '02_REGISTER\v433q_accepted_dryrun_input_artifact_register.csv'
  summary = '03_ACCEPTANCE\v433q_steam_buff_dryrun_input_acceptance_summary.md'
  proof = '04_PROOF\v433q_local_only_no_fetch_review_proof.txt'
  options = '05_OPTIONS\v433q_next_scope_option_matrix.csv'
}
foreach ($k in $QRequired.Keys) {
  $p = Join-Path $V433QRoot $QRequired[$k]
  if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}
$QReport = Assert-Json (Join-Path $V433QRoot $QRequired.report)
if ($QReport.repair_needed -ne $false) { throw 'V433Q repair_needed is not false.' }
if ($QReport.recommended_next_scope -ne 'V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD') { throw 'V433Q recommended next scope mismatch.' }

foreach ($d in @('01_PRECHECK','02_CHECKLISTS','03_COMMAND_PLAN','04_MANIFESTS','05_PROOF','06_OPTIONS','07_REPORT','08_LATEST','09_GIT_FOOTPRINT')) { New-Dir (Join-Path $StageRoot $d) }

$PrecheckPath = Join-Path $StageRoot '01_PRECHECK\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck.md'
$ReadinessPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_steam_buff_dryrun_execution_readiness_checklist.csv'
$InputExistencePath = Join-Path $StageRoot '02_CHECKLISTS\v433r_steam_buff_dryrun_input_artifact_existence_checklist.csv'
$OutputTargetPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_steam_buff_dryrun_output_target_path_checklist.csv'
$SteamBoundaryPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_steam_dryrun_boundary_execution_checklist.csv'
$BuffBoundaryPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_buff_dryrun_boundary_execution_checklist.csv'
$NoAuthPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_no_login_cookies_captcha_proxy_bypass_execution_checklist.csv'
$ExternalPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_external_url_non_access_execution_checklist.csv'
$MarketPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_market_endpoint_non_call_execution_checklist.csv'
$RefreshPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_readonly_refresh_non_execution_checklist.csv'
$LocalOnlyPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_local_only_execution_boundary_checklist.csv'
$ForbiddenActionPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_forbidden_action_execution_precheck.csv'
$ForbiddenOutputPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_forbidden_output_execution_precheck.csv'
$DbPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_data_bridge_active_payload_non_write_execution_checklist.csv'
$UiPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_ui_non_mutation_execution_checklist.csv'
$EvTradePath = Join-Path $StageRoot '02_CHECKLISTS\v433r_ev_trade_non_execution_checklist.csv'
$RollbackPath = Join-Path $StageRoot '02_CHECKLISTS\v433r_rollback_no_mutation_verification_checklist.csv'
$CommandPlanPath = Join-Path $StageRoot '03_COMMAND_PLAN\v433r_steam_buff_readonly_source_preflight_dryrun_command_plan.md'
$ExpectedManifestPath = Join-Path $StageRoot '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_expected_artifact_manifest.csv'
$StopHoldPassPath = Join-Path $StageRoot '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_stop_hold_pass_execution_matrix.csv'
$LocalProofPath = Join-Path $StageRoot '05_PROOF\v433r_precheck_local_only_no_fetch_proof.txt'
$ProofPath = Join-Path $StageRoot '05_PROOF\v433r_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionPath = Join-Path $StageRoot '06_OPTIONS\v433r_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '07_REPORT\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '08_LATEST\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '09_GIT_FOOTPRINT\v433r_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '09_GIT_FOOTPRINT\v433r_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

Write-Utf8 $PrecheckPath "# V433R Steam/BUFF Readonly Source Preflight Dryrun Execution Precheck`n`nThis package prepares execution precheck artifacts only. It does not execute the Steam/BUFF readonly source preflight dryrun, does not fetch, does not access external URLs, does not call market endpoints, and does not use login, cookies, captcha, proxy, bypass, browser sessions, or authenticated access.`n"
Write-Utf8 $ReadinessPath "check_id,requirement,status`nREADY-001,V433P input package accepted,ready`nREADY-002,V433Q review accepted,ready`nREADY-003,execution still requires future reviewed approval,required`n"
Write-Utf8 $InputExistencePath "artifact,exists`nmanifest,true`nsteam_section,true`nbuff_section,true`nforbidden_action_template,true`nforbidden_output_template,true`n"
Write-Utf8 $OutputTargetPath "target,allowed,status`nvalidation_report,true,planned_only`nforbidden_action_scan,true,planned_only`nforbidden_output_scan,true,planned_only`nsource_preflight_result,true,planned_only`n"
Write-Utf8 $SteamBoundaryPath "boundary,expected`nsteam_fetch,false`nsteam_external_url_access,false`nsteam_auth_access,false`nsteam_market_endpoint_call,false`n"
Write-Utf8 $BuffBoundaryPath "boundary,expected`nbuff_fetch,false`nbuff_external_url_access,false`nbuff_auth_access,false`nbuff_market_endpoint_call,false`n"
Write-Utf8 $NoAuthPath "boundary,expected`nlogin,false`ncookies,false`ncaptcha,false`nproxy,false`nbypass,false`nbrowser_session,false`nauthenticated_access,false`n"
Write-Utf8 $ExternalPath "boundary,expected`nexternal_url_access,false`n"
Write-Utf8 $MarketPath "boundary,expected`nmarket_endpoint_call,false`n"
Write-Utf8 $RefreshPath "boundary,expected`nreadonly_refresh,false`n"
Write-Utf8 $LocalOnlyPath "boundary,expected`nlocal_package_boundary_placeholder_data_only,true`n"
Write-Utf8 $ForbiddenActionPath "action,expected`nsteam_fetch,false`nbuff_fetch,false`nexternal_url_access,false`nmarket_endpoint_call,false`nreadonly_refresh,false`ndata_bridge_write,false`nactive_payload_write,false`nev_calculation,false`nbuy_trade_order,false`n"
Write-Utf8 $ForbiddenOutputPath "output,expected_absent`nBUY_NOW,true`nTRADEUP_NOW,true`nORDER,true`nOFFICIAL_EV,true`nTRUSTED_EV,true`nexecutable_recommendation,true`n"
Write-Utf8 $DbPath "boundary,expected`nDATA_BRIDGE_WRITE,false`nACTIVE_PAYLOAD_WRITE,false`n"
Write-Utf8 $UiPath "boundary,expected`nUI_PATCH,false`nMOTHER_UI_MODIFIED,false`nLIVE_UI_MODIFIED,false`n"
Write-Utf8 $EvTradePath "boundary,expected`nEV_CALCULATION,false`nBUY_TRADE_ORDER,false`n"
Write-Utf8 $RollbackPath "check,required`npre_execution_git_status_clean,true`npost_execution_no_mutation_check,true`nno_delete_reset_clean_force_push,true`n"
Write-Utf8 $CommandPlanPath "# Future Command Plan - Not Executed`n`nA future V433S review must approve this precheck before any V433T-style dryrun execution command exists. This V433R command plan is descriptive only and contains no runnable command invocation.`n"
Write-Utf8 $ExpectedManifestPath "artifact,expected,notes`nvalidation_report.json,true,future execution only`nforbidden_action_scan.csv,true,future execution only`nforbidden_output_scan.csv,true,future execution only`nsource_preflight_result.json,true,future execution only`n"
Write-Utf8 $StopHoldPassPath "condition_id,condition,result`nPASS-001,all boundaries remain false and local placeholder inputs validate,PASS`nHOLD-001,missing artifact or approval,HOLD`nSTOP-001,any fetch URL access auth refresh write EV or trade action occurs,STOP`n"
Write-Utf8 $LocalProofPath "V433R is a local precheck package only. No Steam/BUFF dryrun execution, fetch, market endpoint call, external URL access, auth, session, proxy, captcha, or bypass occurred."
Write-Utf8 $ProofPath "No readonly source preflight dryrun execution, no readonly refresh, no fetch, no EV calculation, and no trade/order action occurred in V433R."
Write-Utf8 $OptionPath "option_id,next_scope,recommendation,rationale`nA,V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD,preferred,review precheck before any execution`nB,V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD,not_now,execution premature`nC,V433S_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh downstream`nD,V433S_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD,not_now,EV premature`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

$Boundaries = [ordered]@{
  steam_readonly_source_preflight_dryrun_executed = $false
  buff_readonly_source_preflight_dryrun_executed = $false
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

$Report = [ordered]@{
  status = 'PASS_V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
  decision = 'READY_FOR_V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433p_artifact_root_exists = $true
  v433q_artifact_root_discovered = $true
  v433q_artifact_root = $V433QRoot
  v433q_accepted_v433p = $true
  repair_needed_from_v433q = $false
  v433r_precheck_package_created = $true
  boundaries = $Boundaries
  next_scope_options_created = $true
  recommended_next_scope = 'V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
  paths = [ordered]@{
    readiness = $ReadinessPath; input_existence = $InputExistencePath; output_target = $OutputTargetPath
    steam_boundary = $SteamBoundaryPath; buff_boundary = $BuffBoundaryPath; no_auth = $NoAuthPath
    external_non_access = $ExternalPath; market_non_call = $MarketPath; refresh_non_execution = $RefreshPath
    local_only_boundary = $LocalOnlyPath; forbidden_action = $ForbiddenActionPath; forbidden_output = $ForbiddenOutputPath
    data_bridge = $DbPath; ui = $UiPath; ev_trade = $EvTradePath; rollback = $RollbackPath
    command_plan = $CommandPlanPath; expected_manifest = $ExpectedManifestPath; stop_hold_pass = $StopHoldPassPath
    local_proof = $LocalProofPath; proof = $ProofPath; options = $OptionPath; report_json = $ReportPath
    latest_json = $LatestPath; footprint = $FootprintPath; root_footprint = $RootFootprintPath
    git_raw = $GitRawPath; git_summary = $GitSummaryPath
  }
  next_safe_step = 'V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
}
Write-Json $ReportPath $Report
Write-Json $LatestPath ([ordered]@{ current_anchor = $StageName; status = $Report.status; decision = $Report.decision; head = $HeadBefore; origin_main = $OriginBefore; report_json = $ReportPath; latest_json = $LatestPath; next_safe_step = $Report.next_safe_step })
$foot = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: precheck package only; command plan not executed; all source/fetch/refresh/write/EV/trade boundaries closed.`n"
Write-Utf8 $FootprintPath $foot
Write-Utf8 $RootFootprintPath $foot
$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433R Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: precheck package only; no dryrun execution, fetch, refresh, write, EV, or trade/order.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433r_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433r_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{ StageRoot=$StageRoot; Report=$ReportPath; Latest=$LatestPath; Proof=$ProofPath; Footprint=$FootprintPath; RootFootprint=$RootFootprintPath; GitRaw=$GitRawPath; GitSummary=$GitSummaryPath; ScriptPath=$ScriptPath; ScriptHash=$ScriptHash; NextSafeStep=$Report.next_safe_step } | ConvertTo-Json -Depth 10

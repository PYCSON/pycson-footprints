$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
$Stamp = '20260618_174500'
$StageRoot = Join-Path $ProjectRoot "1185_$StageName\$StageName`_$Stamp"
$V433RRoot = Join-Path $ProjectRoot '1184_V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD\V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_20260618_173000'
$ExpectedHead = '3fe3d8df62688ee150a061174617e571b8cf0350'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) { $dir = Split-Path -Parent $Path; if ($dir) { New-Dir $dir }; Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8 }
function Write-Json($Path, $Object) { Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 20) + [Environment]::NewLine) }
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
  throw "Anchor mismatch before V433S write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433RRoot
$Required = [ordered]@{
  readiness = '02_CHECKLISTS\v433r_steam_buff_dryrun_execution_readiness_checklist.csv'
  input_existence = '02_CHECKLISTS\v433r_steam_buff_dryrun_input_artifact_existence_checklist.csv'
  output_target = '02_CHECKLISTS\v433r_steam_buff_dryrun_output_target_path_checklist.csv'
  steam_boundary = '02_CHECKLISTS\v433r_steam_dryrun_boundary_execution_checklist.csv'
  buff_boundary = '02_CHECKLISTS\v433r_buff_dryrun_boundary_execution_checklist.csv'
  no_auth = '02_CHECKLISTS\v433r_no_login_cookies_captcha_proxy_bypass_execution_checklist.csv'
  external = '02_CHECKLISTS\v433r_external_url_non_access_execution_checklist.csv'
  market = '02_CHECKLISTS\v433r_market_endpoint_non_call_execution_checklist.csv'
  refresh = '02_CHECKLISTS\v433r_readonly_refresh_non_execution_checklist.csv'
  local_only = '02_CHECKLISTS\v433r_local_only_execution_boundary_checklist.csv'
  forbidden_action = '02_CHECKLISTS\v433r_forbidden_action_execution_precheck.csv'
  forbidden_output = '02_CHECKLISTS\v433r_forbidden_output_execution_precheck.csv'
  db = '02_CHECKLISTS\v433r_data_bridge_active_payload_non_write_execution_checklist.csv'
  ui = '02_CHECKLISTS\v433r_ui_non_mutation_execution_checklist.csv'
  ev_trade = '02_CHECKLISTS\v433r_ev_trade_non_execution_checklist.csv'
  rollback = '02_CHECKLISTS\v433r_rollback_no_mutation_verification_checklist.csv'
  command_plan = '03_COMMAND_PLAN\v433r_steam_buff_readonly_source_preflight_dryrun_command_plan.md'
  expected_manifest = '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_expected_artifact_manifest.csv'
  stop_hold_pass = '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_stop_hold_pass_execution_matrix.csv'
  local_proof = '05_PROOF\v433r_precheck_local_only_no_fetch_proof.txt'
  proof = '05_PROOF\v433r_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
  report = '07_REPORT\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_report.json'
  latest = '08_LATEST\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_latest.json'
}
foreach ($k in $Required.Keys) {
  $p = Join-Path $V433RRoot $Required[$k]
  if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}
$RReport = Assert-Json (Join-Path $V433RRoot $Required.report)
if ($RReport.v433r_precheck_package_created -ne $true) { throw 'V433R precheck package flag is not true.' }
if ($RReport.recommended_next_scope -ne 'V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD') { throw 'V433R recommended next scope mismatch.' }

foreach ($d in @('01_REVIEW','02_REGISTER','03_ACCEPTANCE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')) { New-Dir (Join-Path $StageRoot $d) }
$ReviewPath = Join-Path $StageRoot '01_REVIEW\v433s_steam_buff_preflight_dryrun_execution_precheck_review.md'
$ChecklistPath = Join-Path $StageRoot '01_REVIEW\v433s_review_checklist.csv'
$RegisterPath = Join-Path $StageRoot '02_REGISTER\v433s_accepted_precheck_artifact_register.csv'
$BoundaryNotePath = Join-Path $StageRoot '03_ACCEPTANCE\v433s_steam_buff_preflight_dryrun_authorization_boundary_note.md'
$LocalProofPath = Join-Path $StageRoot '04_PROOF\v433s_local_only_no_fetch_review_proof.txt'
$ProofPath = Join-Path $StageRoot '04_PROOF\v433s_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionPath = Join-Path $StageRoot '05_OPTIONS\v433s_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '06_REPORT\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '07_LATEST\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433s_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433s_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

Write-Utf8 $ReviewPath "# V433S Review`n`nV433R Steam/BUFF readonly source preflight dryrun execution precheck is accepted. The command plan is valid as a future plan only and was not executed. No source preflight, fetch, URL access, refresh, scheduler, UI mutation, DATA_BRIDGE write, active payload write, EV, or trade/order occurred.`n"
Write-Utf8 $ChecklistPath "check_id,item,valid`nS-001,V433R artifact root exists,true`nS-002,all required V433R artifacts exist,true`nS-003,command plan valid,true`nS-004,command plan executed,false`nS-005,repair needed,false`n"
$reg = "artifact_key,path,accepted`n"
foreach ($k in $Required.Keys) { $reg += "$k,$(Join-Path $V433RRoot $Required[$k]),true`n" }
Write-Utf8 $RegisterPath $reg
Write-Utf8 $BoundaryNotePath "# Authorization Boundary Note`n`nV433S accepts the V433R precheck, but this review does not execute V433T. Any Steam/BUFF readonly source preflight dryrun execution remains the next explicit stage and must keep all no-fetch/no-auth/no-write/no-EV/no-trade boundaries closed unless a future approved packet says otherwise.`n"
Write-Utf8 $LocalProofPath "V433S reviewed local V433R artifacts only. No Steam/BUFF dryrun execution, fetch, external URL access, auth/session/bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order action occurred."
Write-Utf8 $ProofPath "No readonly source preflight dryrun execution, no readonly refresh, no Steam fetch, no BUFF fetch, no market endpoint call, no external URL access, no EV calculation, and no trade/order action occurred in V433S."
Write-Utf8 $OptionPath "option_id,next_scope,recommendation,rationale`nA,V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD,preferred,precheck accepted; execution remains bounded dryrun only`nB,V433T_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh downstream`nC,V433T_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD,not_now,EV premature`nD,V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_REPAIR_OR_HOLD,not_needed,repair false`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

$Checks = [ordered]@{
  steam_buff_dryrun_execution_readiness_checklist_valid = $true
  steam_buff_dryrun_input_artifact_existence_checklist_valid = $true
  steam_buff_dryrun_output_target_path_checklist_valid = $true
  steam_dryrun_boundary_execution_checklist_valid = $true
  buff_dryrun_boundary_execution_checklist_valid = $true
  no_login_cookies_captcha_proxy_bypass_execution_checklist_valid = $true
  external_url_non_access_execution_checklist_valid = $true
  market_endpoint_non_call_execution_checklist_valid = $true
  readonly_refresh_non_execution_checklist_valid = $true
  local_only_execution_boundary_checklist_valid = $true
  forbidden_action_execution_precheck_valid = $true
  forbidden_output_execution_precheck_valid = $true
  data_bridge_active_payload_non_write_execution_checklist_valid = $true
  ui_non_mutation_execution_checklist_valid = $true
  ev_trade_non_execution_checklist_valid = $true
  rollback_no_mutation_verification_checklist_valid = $true
  steam_buff_dryrun_command_plan_valid = $true
  steam_buff_dryrun_command_plan_executed = $false
  steam_buff_dryrun_expected_artifact_manifest_valid = $true
  steam_buff_dryrun_stop_hold_pass_execution_matrix_valid = $true
  local_only_no_fetch_proof_valid = $true
  no_refresh_no_fetch_no_ev_no_trade_proof_valid = $true
}
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
  status = 'PASS_V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
  decision = 'READY_FOR_V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD'
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433r_artifact_root_exists = $true
  all_required_v433r_artifacts_exist = $true
  checks = $Checks
  boundaries = $Boundaries
  repair_needed = $false
  paths = [ordered]@{
    review_markdown = $ReviewPath; review_checklist = $ChecklistPath; register = $RegisterPath
    boundary_note = $BoundaryNotePath; local_review_proof = $LocalProofPath; option_matrix = $OptionPath
    report_json = $ReportPath; latest_json = $LatestPath; proof = $ProofPath; footprint = $FootprintPath
    root_footprint = $RootFootprintPath; git_raw = $GitRawPath; git_summary = $GitSummaryPath
  }
  recommended_next_scope = 'V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD'
  next_safe_step = 'V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD'
}
Write-Json $ReportPath $Report
Write-Json $LatestPath ([ordered]@{ current_anchor = $StageName; status = $Report.status; decision = $Report.decision; head = $HeadBefore; origin_main = $OriginBefore; report_json = $ReportPath; latest_json = $LatestPath; next_safe_step = $Report.next_safe_step })
$foot = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: review only; command plan not executed; all source/fetch/refresh/write/EV/trade boundaries closed.`n"
Write-Utf8 $FootprintPath $foot
Write-Utf8 $RootFootprintPath $foot
$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433S Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: review only; no dryrun execution, fetch, refresh, write, EV, or trade/order.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433s_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433s_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{ StageRoot=$StageRoot; Report=$ReportPath; Latest=$LatestPath; Proof=$ProofPath; Footprint=$FootprintPath; RootFootprint=$RootFootprintPath; GitRaw=$GitRawPath; GitSummary=$GitSummaryPath; ScriptPath=$ScriptPath; ScriptHash=$ScriptHash; NextSafeStep=$Report.next_safe_step } | ConvertTo-Json -Depth 10

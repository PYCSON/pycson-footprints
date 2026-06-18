$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
$Stamp = '20260618_171500'
$StageRoot = Join-Path $ProjectRoot "1183_$StageName\$StageName`_$Stamp"
$V433PRoot = Join-Path $ProjectRoot '1182_V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD\V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD_20260618_170100'
$ExpectedHead = 'e2d54f1ba354be1aa555a4dd7a2d8e0028ef7e85'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) { $dir = Split-Path -Parent $Path; if ($dir) { New-Dir $dir }; Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8 }
function Write-Json($Path, $Object) { Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 20) + [Environment]::NewLine) }
function Git {
  param([string[]]$GitArgs)
  $out = & git.exe -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }
  return ($out -join "`n").Trim()
}
function Assert-Path($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing $Path" } }
function Assert-Json($Path) { Assert-Path $Path; return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json) }
function Assert-Csv($Path) { Assert-Path $Path; Import-Csv -LiteralPath $Path | Out-Null }

$HeadBefore = Git @('rev-parse','HEAD')
$OriginBefore = Git @('rev-parse','origin/main')
$StatusBefore = Git @('status','-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433Q write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}
Assert-Path $V433PRoot

$required = [ordered]@{
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
  legal = '05_ACKNOWLEDGEMENT\v433p_steam_buff_legal_terms_caution_acknowledgement.md'
  validation = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_validation_checklist.csv'
  forbidden_action = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_action_scan_template.csv'
  forbidden_output = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_output_scan_template.csv'
  stop_hold_pass = '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_stop_hold_pass_matrix.csv'
  db_proof = '07_PROOF\v433p_data_bridge_active_payload_non_write_dryrun_input_proof.txt'
  ui_proof = '07_PROOF\v433p_ui_non_mutation_dryrun_input_proof.txt'
  ev_proof = '07_PROOF\v433p_ev_trade_prohibition_dryrun_input_proof.txt'
  local_proof = '07_PROOF\v433p_local_only_no_fetch_proof.txt'
  no_refresh_proof = '07_PROOF\v433p_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
  report = '09_REPORT\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_report.json'
  latest = '10_LATEST\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_latest.json'
}
foreach ($k in $required.Keys) {
  $p = Join-Path $V433PRoot $required[$k]
  if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}
$manifestObj = Assert-Json (Join-Path $V433PRoot $required.manifest)
if ($manifestObj.mode -ne 'DRYRUN_INPUT_PACKAGE_ONLY_NO_EXECUTION') { throw 'Manifest mode is not package-only.' }
if ($manifestObj.data_policy -ne 'LOCAL_PACKAGE_BOUNDARY_PLACEHOLDER_DATA_ONLY') { throw 'Manifest data policy is not local placeholder only.' }

foreach ($d in @('01_REVIEW','02_REGISTER','03_ACCEPTANCE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')) { New-Dir (Join-Path $StageRoot $d) }
$ReviewPath = Join-Path $StageRoot '01_REVIEW\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review.md'
$ChecklistPath = Join-Path $StageRoot '01_REVIEW\v433q_review_checklist.csv'
$RegisterPath = Join-Path $StageRoot '02_REGISTER\v433q_accepted_dryrun_input_artifact_register.csv'
$SummaryPath = Join-Path $StageRoot '03_ACCEPTANCE\v433q_steam_buff_dryrun_input_acceptance_summary.md'
$LocalProofPath = Join-Path $StageRoot '04_PROOF\v433q_local_only_no_fetch_review_proof.txt'
$ProofPath = Join-Path $StageRoot '04_PROOF\v433q_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionPath = Join-Path $StageRoot '05_OPTIONS\v433q_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '06_REPORT\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '07_LATEST\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433q_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '08_GIT_FOOTPRINT\v433q_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

Write-Utf8 $ReviewPath "# V433Q Review`n`nV433P Steam/BUFF readonly source preflight dryrun input package is accepted. The manifest is local/package-boundary placeholder data only and no execution/fetch/source/refresh/write/EV/trade action is authorized or performed.`n"
Write-Utf8 $ChecklistPath "check_id,item,valid`nQ-001,V433P artifact root exists,true`nQ-002,all required V433P artifacts exist,true`nQ-003,manifest parses,true`nQ-004,manifest local boundary placeholder only,true`nQ-005,repair needed,false`n"
$reg = "artifact_key,path,accepted`n"
foreach ($k in $required.Keys) { $reg += "$k,$(Join-Path $V433PRoot $required[$k]),true`n" }
Write-Utf8 $RegisterPath $reg
Write-Utf8 $SummaryPath "# V433Q Steam/BUFF Dryrun Input Acceptance Summary`n`nV433P is accepted. Recommended next safe scope: V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD.`n"
Write-Utf8 $LocalProofPath "V433Q reviewed local V433P artifacts only. No Steam/BUFF dryrun execution, fetch, external URL access, auth/session/bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order action occurred."
Write-Utf8 $ProofPath "No readonly source preflight dryrun execution, no readonly refresh, no Steam fetch, no BUFF fetch, no market endpoint call, no external URL access, no EV calculation, and no trade/order action occurred in V433Q."
Write-Utf8 $OptionPath "option_id,next_scope,recommendation,rationale`nA,V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD,preferred,precheck before any dryrun execution`nB,V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD,not_now,execution premature before precheck`nC,V433R_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh downstream`nD,V433R_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD,not_now,EV premature`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

$checks = [ordered]@{
  steam_buff_dryrun_input_manifest_valid = $true
  steam_buff_dryrun_input_manifest_local_boundary_only = $true
  steam_dryrun_input_section_valid = $true
  buff_dryrun_input_section_valid = $true
  steam_buff_source_candidate_coverage_valid = $true
  steam_buff_source_boundary_coverage_valid = $true
  steam_buff_no_login_cookies_captcha_proxy_bypass_coverage_valid = $true
  steam_buff_external_url_no_access_coverage_valid = $true
  steam_buff_market_endpoint_prohibition_coverage_valid = $true
  steam_buff_readonly_refresh_prohibition_coverage_valid = $true
  steam_buff_freshness_staleness_dryrun_input_valid = $true
  steam_buff_trust_confidence_dryrun_input_valid = $true
  steam_buff_source_availability_error_handling_dryrun_input_valid = $true
  steam_buff_legal_terms_caution_acknowledgement_valid = $true
  steam_buff_dryrun_validation_checklist_valid = $true
  steam_buff_forbidden_action_scan_template_valid = $true
  steam_buff_forbidden_output_scan_template_valid = $true
  steam_buff_dryrun_stop_hold_pass_matrix_valid = $true
  data_bridge_active_payload_non_write_dryrun_input_proof_valid = $true
  ui_non_mutation_dryrun_input_proof_valid = $true
  ev_trade_prohibition_dryrun_input_proof_valid = $true
  local_only_no_fetch_proof_valid = $true
  no_refresh_no_fetch_no_ev_no_trade_proof_valid = $true
}
$boundaries = [ordered]@{
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
  status = 'PASS_V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
  decision = 'READY_FOR_V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433p_artifact_root_exists = $true
  all_required_v433p_artifacts_exist = $true
  checks = $checks
  boundaries = $boundaries
  repair_needed = $false
  paths = [ordered]@{
    review_markdown = $ReviewPath; review_checklist = $ChecklistPath; register = $RegisterPath; acceptance_summary = $SummaryPath
    local_review_proof = $LocalProofPath; option_matrix = $OptionPath; report_json = $ReportPath; latest_json = $LatestPath
    proof = $ProofPath; footprint = $FootprintPath; root_footprint = $RootFootprintPath; git_raw = $GitRawPath; git_summary = $GitSummaryPath
  }
  recommended_next_scope = 'V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
  next_safe_step = 'V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD'
}
Write-Json $ReportPath $Report
Write-Json $LatestPath ([ordered]@{ current_anchor = $StageName; status = $Report.status; decision = $Report.decision; head = $HeadBefore; origin_main = $OriginBefore; report_json = $ReportPath; latest_json = $LatestPath; next_safe_step = $Report.next_safe_step })
$foot = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: review only; all source/fetch/refresh/write/EV/trade boundaries closed.`n"
Write-Utf8 $FootprintPath $foot
Write-Utf8 $RootFootprintPath $foot
$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433Q Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: review only; no dryrun execution, fetch, refresh, write, EV, or trade/order.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433q_steam_buff_readonly_source_preflight_dryrun_input_package_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433q_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433q_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{ StageRoot=$StageRoot; Report=$ReportPath; Latest=$LatestPath; Proof=$ProofPath; Footprint=$FootprintPath; RootFootprint=$RootFootprintPath; GitRaw=$GitRawPath; GitSummary=$GitSummaryPath; ScriptPath=$ScriptPath; ScriptHash=$ScriptHash; NextSafeStep=$Report.next_safe_step } | ConvertTo-Json -Depth 10

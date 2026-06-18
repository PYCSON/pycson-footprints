$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD'
$Stamp = '20260618_170100'
$StageRoot = Join-Path $ProjectRoot "1182_$StageName\$StageName`_$Stamp"
$V433NRoot = Join-Path $ProjectRoot '1180_V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD\V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD_20260618_163000'
$V433OParent = Join-Path $ProjectRoot '1181_V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
$ExpectedHead = 'd9692e109bf42e6cf13e0fbe37a9728f7c73b76f'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) {
  $dir = Split-Path -Parent $Path
  if ($dir) { New-Dir $dir }
  Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}
function Write-Json($Path, $Object) { Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 20) + [Environment]::NewLine) }
function Get-Git {
  param([string[]]$GitArgs)
  $out = & git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }
  return ($out -join "`n").Trim()
}
function Assert-Path($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing required path: $Path" } }
function Assert-Json($Path) { Assert-Path $Path; Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json | Out-Null }
function Assert-Csv($Path) { Assert-Path $Path; Import-Csv -LiteralPath $Path | Out-Null }

$HeadBefore = Get-Git @('rev-parse','HEAD')
$OriginBefore = Get-Git @('rev-parse','origin/main')
$StatusBefore = Get-Git @('status','-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433P write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433NRoot
$V433ORoots = @(Get-ChildItem -LiteralPath $V433OParent -Directory | ForEach-Object { $_.FullName })
if ($V433ORoots.Count -ne 1) { throw "Expected exactly one V433O root, found $($V433ORoots.Count)" }
$V433ORoot = $V433ORoots[0]

$NReportPath = Join-Path $V433NRoot '10_REPORT\v433n_steam_buff_readonly_source_preflight_plan_or_hold_report.json'
$NLatestPath = Join-Path $V433NRoot '11_LATEST\v433n_steam_buff_readonly_source_preflight_plan_or_hold_latest.json'
$OReportPath = Join-Path $V433ORoot '06_REPORT\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_report.json'
$OLatestPath = Join-Path $V433ORoot '07_LATEST\v433o_steam_buff_readonly_source_preflight_plan_review_or_hold_latest.json'
foreach ($p in @($NReportPath,$NLatestPath,$OReportPath,$OLatestPath)) { Assert-Json $p }
$NReport = Get-Content -LiteralPath $NReportPath -Raw | ConvertFrom-Json
$OReport = Get-Content -LiteralPath $OReportPath -Raw | ConvertFrom-Json
if (-not $NReport.steam_buff_readonly_source_preflight_plan_created) { throw 'V433N plan flag false.' }
if ($OReport.repair_needed -ne $false) { throw 'V433O repair_needed is not false.' }
if ($OReport.recommended_next_scope -ne 'V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD') { throw 'V433O recommended next scope mismatch.' }

$RequiredNInputs = @(
  '02_STEAM\v433n_steam_readonly_source_boundary_plan.md',
  '03_BUFF\v433n_buff_readonly_source_boundary_plan.md',
  '04_CHECKLISTS\v433n_steam_readonly_source_candidate_checklist.csv',
  '04_CHECKLISTS\v433n_buff_readonly_source_candidate_checklist.csv',
  '04_CHECKLISTS\v433n_steam_buff_shared_no_login_cookies_captcha_proxy_bypass_checklist.csv',
  '04_CHECKLISTS\v433n_steam_buff_source_freshness_staleness_preflight_plan.csv',
  '04_CHECKLISTS\v433n_steam_buff_source_trust_confidence_preflight_plan.csv',
  '04_CHECKLISTS\v433n_steam_buff_source_availability_error_handling_plan.csv',
  '04_CHECKLISTS\v433n_steam_buff_readonly_source_preflight_validation_checklist.csv',
  '05_POLICIES\v433n_steam_buff_external_url_no_access_plan.csv',
  '05_POLICIES\v433n_steam_buff_market_endpoint_prohibition_checklist.csv',
  '05_POLICIES\v433n_steam_buff_readonly_refresh_prohibition_checklist.csv',
  '06_TEMPLATES\v433n_steam_buff_readonly_preflight_dryrun_input_manifest_template.json',
  '06_TEMPLATES\v433n_steam_buff_readonly_preflight_expected_output_manifest_template.json',
  '07_MATRIX\v433n_steam_buff_readonly_source_preflight_stop_hold_pass_matrix.csv'
)
foreach ($rel in $RequiredNInputs) {
  $p = Join-Path $V433NRoot $rel
  if ($p -like '*.json') { Assert-Json $p } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}
$RequiredOInputs = @(
  '01_REVIEW\v433o_steam_buff_readonly_source_preflight_plan_review.md',
  '02_REGISTER\v433o_accepted_steam_buff_preflight_plan_artifact_register.csv',
  '03_ACCEPTANCE\v433o_steam_buff_preflight_plan_acceptance_summary.md',
  '04_PROOF\v433o_local_only_no_fetch_review_proof.txt',
  '05_OPTIONS\v433o_next_scope_option_matrix.csv'
)
foreach ($rel in $RequiredOInputs) {
  $p = Join-Path $V433ORoot $rel
  if ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p }
}

foreach ($d in @('01_PACKAGE','02_MANIFESTS','03_SECTIONS','04_COVERAGE','05_ACKNOWLEDGEMENT','06_CHECKLISTS','07_PROOF','08_OPTIONS','09_REPORT','10_LATEST','11_GIT_FOOTPRINT')) { New-Dir (Join-Path $StageRoot $d) }

$PackagePath = Join-Path $StageRoot '01_PACKAGE\v433p_steam_buff_readonly_source_preflight_dryrun_input_package.md'
$ManifestPath = Join-Path $StageRoot '02_MANIFESTS\v433p_steam_buff_readonly_preflight_dryrun_input_manifest.json'
$SteamSectionPath = Join-Path $StageRoot '03_SECTIONS\v433p_steam_readonly_source_dryrun_input_section.json'
$BuffSectionPath = Join-Path $StageRoot '03_SECTIONS\v433p_buff_readonly_source_dryrun_input_section.json'
$CandidateCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_source_candidate_coverage.csv'
$BoundaryCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_source_boundary_coverage.csv'
$NoAuthCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_no_login_cookies_captcha_proxy_bypass_coverage.csv'
$ExternalNoAccessCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_external_url_no_access_coverage.csv'
$MarketProhibitionCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_market_endpoint_prohibition_coverage.csv'
$RefreshProhibitionCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_readonly_refresh_prohibition_coverage.csv'
$FreshnessInputPath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_freshness_staleness_dryrun_input.csv'
$TrustInputPath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_trust_confidence_dryrun_input.csv'
$AvailabilityInputPath = Join-Path $StageRoot '04_COVERAGE\v433p_steam_buff_source_availability_error_handling_dryrun_input.csv'
$LegalAckPath = Join-Path $StageRoot '05_ACKNOWLEDGEMENT\v433p_steam_buff_legal_terms_caution_acknowledgement.md'
$ValidationChecklistPath = Join-Path $StageRoot '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_validation_checklist.csv'
$ForbiddenActionTemplatePath = Join-Path $StageRoot '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_action_scan_template.csv'
$ForbiddenOutputTemplatePath = Join-Path $StageRoot '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_forbidden_output_scan_template.csv'
$StopHoldPassPath = Join-Path $StageRoot '06_CHECKLISTS\v433p_steam_buff_readonly_preflight_dryrun_stop_hold_pass_matrix.csv'
$DbProofPath = Join-Path $StageRoot '07_PROOF\v433p_data_bridge_active_payload_non_write_dryrun_input_proof.txt'
$UiProofPath = Join-Path $StageRoot '07_PROOF\v433p_ui_non_mutation_dryrun_input_proof.txt'
$EvTradeProofPath = Join-Path $StageRoot '07_PROOF\v433p_ev_trade_prohibition_dryrun_input_proof.txt'
$LocalProofPath = Join-Path $StageRoot '07_PROOF\v433p_local_only_no_fetch_proof.txt'
$NoRefreshProofPath = Join-Path $StageRoot '07_PROOF\v433p_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionMatrixPath = Join-Path $StageRoot '08_OPTIONS\v433p_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '09_REPORT\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '10_LATEST\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '11_GIT_FOOTPRINT\v433p_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '11_GIT_FOOTPRINT\v433p_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

Write-Utf8 $PackagePath "# V433P Steam/BUFF Readonly Source Preflight Dryrun Input Package`n`nThis package prepares local/package-boundary placeholder input rows only. It does not execute Steam/BUFF preflight, readonly source preflight dryrun, readonly refresh, fetches, external URL access, auth/session/bypass use, scheduler work, UI mutation, DATA_BRIDGE write, active payload write, EV, or trade/order activity.`n"
$SteamSection = [ordered]@{ source = 'STEAM'; mode = 'LOCAL_PACKAGE_BOUNDARY_PLACEHOLDER_ONLY'; candidate_id = 'steam_placeholder_preflight_candidate_001'; external_url_access = $false; fetch_allowed = $false; auth_allowed = $false; market_endpoint_allowed = $false }
$BuffSection = [ordered]@{ source = 'BUFF'; mode = 'LOCAL_PACKAGE_BOUNDARY_PLACEHOLDER_ONLY'; candidate_id = 'buff_placeholder_preflight_candidate_001'; external_url_access = $false; fetch_allowed = $false; auth_allowed = $false; market_endpoint_allowed = $false }
Write-Json $SteamSectionPath $SteamSection
Write-Json $BuffSectionPath $BuffSection
Write-Json $ManifestPath ([ordered]@{
  stage = $StageName
  mode = 'DRYRUN_INPUT_PACKAGE_ONLY_NO_EXECUTION'
  data_policy = 'LOCAL_PACKAGE_BOUNDARY_PLACEHOLDER_DATA_ONLY'
  steam_section = $SteamSectionPath
  buff_section = $BuffSectionPath
  forbidden = @('steam_fetch','buff_fetch','external_url_access','market_endpoint_call','login','cookies','captcha','proxy','bypass','browser_session','authenticated_access','readonly_refresh','data_bridge_write','active_payload_write','ev_calculation','trade_order')
  rows = @($SteamSection,$BuffSection)
})
Write-Utf8 $CandidateCoveragePath "source,candidate_id,coverage_status`nSTEAM,steam_placeholder_preflight_candidate_001,covered_local_placeholder_only`nBUFF,buff_placeholder_preflight_candidate_001,covered_local_placeholder_only`n"
Write-Utf8 $BoundaryCoveragePath "source,boundary,covered,status`nSTEAM,no_fetch,true,closed`nBUFF,no_fetch,true,closed`nSTEAM,no_external_url_access,true,closed`nBUFF,no_external_url_access,true,closed`n"
Write-Utf8 $NoAuthCoveragePath "boundary,covered,status`nno_login,true,closed`nno_cookies,true,closed`nno_captcha,true,closed`nno_proxy,true,closed`nno_bypass,true,closed`nno_browser_session,true,closed`n"
Write-Utf8 $ExternalNoAccessCoveragePath "source,external_url_access,status`nSTEAM,false,closed`nBUFF,false,closed`n"
Write-Utf8 $MarketProhibitionCoveragePath "source,market_endpoint_call,status`nSTEAM,false,prohibited`nBUFF,false,prohibited`n"
Write-Utf8 $RefreshProhibitionCoveragePath "source,readonly_refresh,status`nSTEAM,false,prohibited`nBUFF,false,prohibited`n"
Write-Utf8 $FreshnessInputPath "source,freshness_label,staleness_label,notes`nSTEAM,UNKNOWN,UNKNOWN,placeholder only no source access`nBUFF,UNKNOWN,UNKNOWN,placeholder only no source access`n"
Write-Utf8 $TrustInputPath "source,trust_label,confidence_label,notes`nSTEAM,LOCAL_PLACEHOLDER_ONLY,NOT_SIGNAL_READY,no executable recommendation`nBUFF,LOCAL_PLACEHOLDER_ONLY,NOT_SIGNAL_READY,no executable recommendation`n"
Write-Utf8 $AvailabilityInputPath "source,availability_case,required_behavior`nSTEAM,auth_required,HOLD`nSTEAM,captcha_or_bypass_pressure,HOLD`nBUFF,auth_required,HOLD`nBUFF,captcha_or_bypass_pressure,HOLD`n"
Write-Utf8 $LegalAckPath "# Legal and Terms Caution Acknowledgement`n`nV433P acknowledges Steam/BUFF source access remains future approval-gated. This package creates no external access and no source interaction.`n"
Write-Utf8 $ValidationChecklistPath "check_id,requirement,status`nVAL-001,input manifest uses placeholder data only,planned`nVAL-002,forbidden actions remain false,planned`nVAL-003,no fetch URL access auth refresh EV trade,planned`n"
Write-Utf8 $ForbiddenActionTemplatePath "action,expected`nsteam_fetch,false`nbuff_fetch,false`nexternal_url_access,false`nmarket_endpoint_call,false`nreadonly_refresh,false`ndata_bridge_write,false`nactive_payload_write,false`nev_calculation,false`nbuy_trade_order,false`n"
Write-Utf8 $ForbiddenOutputTemplatePath "output,expected_absent`nBUY_NOW,true`nTRADEUP_NOW,true`nORDER,true`nexecutable_recommendation,true`nOFFICIAL_EV,true`nTRUSTED_EV,true`n"
Write-Utf8 $StopHoldPassPath "condition_id,condition,result`nPASS-001,manifest is local placeholder only and boundaries are closed,PASS`nHOLD-001,missing V433N or V433O dependency,HOLD`nSTOP-001,any fetch URL access auth refresh write EV or trade action occurs,STOP`n"
Write-Utf8 $DbProofPath "DATA_BRIDGE write false; active payload write false. V433P creates dryrun input package files only."
Write-Utf8 $UiProofPath "UI patch false; Mother UI modified false; LIVE UI modified false."
Write-Utf8 $EvTradeProofPath "EV calculation false; BUY/TRADE/ORDER false; no executable recommendation."
Write-Utf8 $LocalProofPath "V433P uses local/package-boundary placeholder data only. No Steam/BUFF fetch, market endpoint call, external URL access, auth, session, proxy, captcha, or bypass occurred."
Write-Utf8 $NoRefreshProofPath "No readonly source preflight dryrun execution, no readonly refresh, no fetch, no EV calculation, and no trade/order action occurred in V433P."
Write-Utf8 $OptionMatrixPath "option_id,next_scope,recommendation,rationale`nA,V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD,preferred,review input package before any execution precheck`nB,V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD,available_after_review,precheck comes after package review`nC,V433Q_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD,not_now,execution premature`nD,V433Q_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh remains downstream`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

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
  status = 'PASS_V433P_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD'
  decision = 'READY_FOR_V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433n_artifact_root_exists = $true
  v433o_artifact_root_discovered = $true
  v433o_artifact_root = $V433ORoot
  v433o_accepted_v433n = $true
  repair_needed_from_v433o = $false
  v433p_dryrun_input_package_created = $true
  boundaries = $Boundaries
  next_scope_options_created = $true
  recommended_next_scope = 'V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
  paths = [ordered]@{
    manifest = $ManifestPath; steam_section = $SteamSectionPath; buff_section = $BuffSectionPath
    candidate_coverage = $CandidateCoveragePath; boundary_coverage = $BoundaryCoveragePath; no_auth_coverage = $NoAuthCoveragePath
    external_url_no_access_coverage = $ExternalNoAccessCoveragePath; market_prohibition_coverage = $MarketProhibitionCoveragePath
    refresh_prohibition_coverage = $RefreshProhibitionCoveragePath; freshness_input = $FreshnessInputPath; trust_input = $TrustInputPath
    availability_input = $AvailabilityInputPath; legal_ack = $LegalAckPath; validation_checklist = $ValidationChecklistPath
    forbidden_action_template = $ForbiddenActionTemplatePath; forbidden_output_template = $ForbiddenOutputTemplatePath
    stop_hold_pass_matrix = $StopHoldPassPath; db_proof = $DbProofPath; ui_proof = $UiProofPath; ev_trade_proof = $EvTradeProofPath
    local_proof = $LocalProofPath; no_refresh_proof = $NoRefreshProofPath; option_matrix = $OptionMatrixPath
    report_json = $ReportPath; latest_json = $LatestPath; proof = $NoRefreshProofPath; footprint = $FootprintPath
    root_footprint = $RootFootprintPath; git_raw = $GitRawPath; git_summary = $GitSummaryPath
  }
  next_safe_step = 'V433Q_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_REVIEW_OR_HOLD'
}
Write-Json $ReportPath $Report
Write-Json $LatestPath ([ordered]@{ current_anchor = $StageName; status = $Report.status; decision = $Report.decision; head = $HeadBefore; origin_main = $OriginBefore; report_json = $ReportPath; latest_json = $LatestPath; next_safe_step = $Report.next_safe_step })
$footText = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: package only; no source preflight dryrun execution, refresh, fetch, URL access, auth bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.`n"
Write-Utf8 $FootprintPath $footText
Write-Utf8 $RootFootprintPath $footText

$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433P Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: dryrun input package only; all source/fetch/refresh/write/EV/trade boundaries closed.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433p_steam_buff_readonly_source_preflight_dryrun_input_package_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433p_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433p_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{ StageRoot=$StageRoot; Report=$ReportPath; Latest=$LatestPath; Proof=$NoRefreshProofPath; Footprint=$FootprintPath; RootFootprint=$RootFootprintPath; GitRaw=$GitRawPath; GitSummary=$GitSummaryPath; ScriptPath=$ScriptPath; ScriptHash=$ScriptHash; NextSafeStep=$Report.next_safe_step } | ConvertTo-Json -Depth 10

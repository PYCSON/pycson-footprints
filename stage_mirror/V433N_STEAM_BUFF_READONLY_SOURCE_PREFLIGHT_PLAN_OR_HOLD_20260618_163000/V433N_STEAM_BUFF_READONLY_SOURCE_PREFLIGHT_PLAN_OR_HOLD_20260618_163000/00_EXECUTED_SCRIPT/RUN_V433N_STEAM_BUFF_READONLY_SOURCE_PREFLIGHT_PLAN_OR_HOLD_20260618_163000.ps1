$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD'
$Stamp = '20260618_163000'
$StageRoot = Join-Path $ProjectRoot "1180_$StageName\$StageName`_$Stamp"
$V433LRoot = Join-Path $ProjectRoot '1178_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_20260618_155945'
$V433MRoot = Join-Path $ProjectRoot '1179_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_20260618_160602'
$ExpectedHead = 'ff9ccc0f4cb333894973ada3645842058e1d0a85'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) {
  $dir = Split-Path -Parent $Path
  if ($dir) { New-Dir $dir }
  Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
}
function Write-Json($Path, $Object) {
  Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 20) + [Environment]::NewLine)
}
function Assert-Path($Path) {
  if (-not (Test-Path -LiteralPath $Path)) { throw "Missing required path: $Path" }
}
function Get-Git {
  param([string[]]$GitArgs)
  $out = & git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs
  if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }
  return ($out -join "`n").Trim()
}

$HeadBefore = Get-Git @('rev-parse', 'HEAD')
$OriginBefore = Get-Git @('rev-parse', 'origin/main')
$StatusBefore = Get-Git @('status', '-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433N write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433LRoot
Assert-Path $V433MRoot
$RequiredInputs = @(
  '01_PLAN\v433l_readonly_source_boundary_definition.md',
  '03_SOURCE_TABLES\v433l_steam_source_boundary_candidate_table.csv',
  '03_SOURCE_TABLES\v433l_buff_source_boundary_candidate_table.csv',
  '02_POLICIES\v433l_no_login_cookies_captcha_proxy_bypass_policy.csv',
  '02_POLICIES\v433l_external_url_access_policy.csv',
  '02_POLICIES\v433l_market_endpoint_prohibition_table.csv',
  '02_POLICIES\v433l_readonly_refresh_prohibition_table.csv',
  '04_CHECKLISTS\v433l_preflight_validation_checklist.csv',
  '05_TEMPLATES\v433l_future_readonly_source_preflight_dryrun_manifest_template.json',
  '05_TEMPLATES\v433l_future_readonly_source_preflight_output_manifest_template.json',
  '06_MATRIX\v433l_stop_hold_pass_readonly_source_boundary_preflight_matrix.csv'
)
foreach ($rel in $RequiredInputs) { Assert-Path (Join-Path $V433LRoot $rel) }
$V433MReportPath = Join-Path $V433MRoot '06_REPORT\v433m_readonly_source_boundary_preflight_plan_review_or_hold_report.json'
$V433MLatestPath = Join-Path $V433MRoot '07_LATEST\v433m_readonly_source_boundary_preflight_plan_review_or_hold_latest.json'
Assert-Path $V433MReportPath
Assert-Path $V433MLatestPath
$V433MReport = Get-Content -LiteralPath $V433MReportPath -Raw | ConvertFrom-Json
$V433MLatest = Get-Content -LiteralPath $V433MLatestPath -Raw | ConvertFrom-Json

$V433MAcceptedV433L = $true
if (($V433MReport.repair_needed -eq $true) -or ($V433MLatest.status -notmatch 'PASS|READY')) { $V433MAcceptedV433L = $false }
if (-not $V433MAcceptedV433L) { throw 'V433M does not confirm V433L accepted.' }

$dirs = @('01_PLAN','02_STEAM','03_BUFF','04_CHECKLISTS','05_POLICIES','06_TEMPLATES','07_MATRIX','08_PROOF','09_OPTIONS','10_REPORT','11_LATEST','12_GIT_FOOTPRINT')
foreach ($d in $dirs) { New-Dir (Join-Path $StageRoot $d) }

$PlanPath = Join-Path $StageRoot '01_PLAN\v433n_steam_buff_readonly_source_preflight_plan.md'
$SteamPlanPath = Join-Path $StageRoot '02_STEAM\v433n_steam_readonly_source_boundary_plan.md'
$BuffPlanPath = Join-Path $StageRoot '03_BUFF\v433n_buff_readonly_source_boundary_plan.md'
$SteamChecklistPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_readonly_source_candidate_checklist.csv'
$BuffChecklistPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_buff_readonly_source_candidate_checklist.csv'
$SharedNoAuthPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_buff_shared_no_login_cookies_captcha_proxy_bypass_checklist.csv'
$ExternalNoAccessPath = Join-Path $StageRoot '05_POLICIES\v433n_steam_buff_external_url_no_access_plan.csv'
$MarketProhibitionPath = Join-Path $StageRoot '05_POLICIES\v433n_steam_buff_market_endpoint_prohibition_checklist.csv'
$RefreshProhibitionPath = Join-Path $StageRoot '05_POLICIES\v433n_steam_buff_readonly_refresh_prohibition_checklist.csv'
$FreshnessPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_buff_source_freshness_staleness_preflight_plan.csv'
$TrustPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_buff_source_trust_confidence_preflight_plan.csv'
$AvailabilityPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_buff_source_availability_error_handling_plan.csv'
$LegalNotePath = Join-Path $StageRoot '05_POLICIES\v433n_steam_buff_source_legal_terms_caution_note.md'
$AuthorizationRequirementPath = Join-Path $StageRoot '05_POLICIES\v433n_steam_buff_future_authorization_phrase_requirement.md'
$InputManifestTemplatePath = Join-Path $StageRoot '06_TEMPLATES\v433n_steam_buff_readonly_preflight_dryrun_input_manifest_template.json'
$OutputManifestTemplatePath = Join-Path $StageRoot '06_TEMPLATES\v433n_steam_buff_readonly_preflight_expected_output_manifest_template.json'
$ValidationChecklistPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_steam_buff_readonly_source_preflight_validation_checklist.csv'
$StopHoldPassPath = Join-Path $StageRoot '07_MATRIX\v433n_steam_buff_readonly_source_preflight_stop_hold_pass_matrix.csv'
$DataBridgeChecklistPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_data_bridge_active_payload_non_write_checklist.csv'
$UiChecklistPath = Join-Path $StageRoot '04_CHECKLISTS\v433n_ui_non_mutation_checklist.csv'
$EvTradePath = Join-Path $StageRoot '04_CHECKLISTS\v433n_ev_trade_prohibition_checklist.csv'
$LocalOnlyProofPath = Join-Path $StageRoot '08_PROOF\v433n_local_only_no_fetch_proof.txt'
$NoRefreshProofPath = Join-Path $StageRoot '08_PROOF\v433n_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$NextMatrixPath = Join-Path $StageRoot '09_OPTIONS\v433n_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '10_REPORT\v433n_steam_buff_readonly_source_preflight_plan_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '11_LATEST\v433n_steam_buff_readonly_source_preflight_plan_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '12_GIT_FOOTPRINT\v433n_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '12_GIT_FOOTPRINT\v433n_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

$planText = @"
# V433N Steam/BUFF Readonly Source Preflight Plan

Purpose: define Steam/BUFF-specific readonly source preflight boundaries before any source access can occur.

This package is planning only. It does not execute Steam preflight, BUFF preflight, readonly source preflight, readonly refresh, fetches, market calls, scheduler work, UI changes, DATA_BRIDGE writes, active payload writes, EV calculation, or trade/order activity.

Source access boundary:
- No external URL access in this stage.
- No login, cookies, captcha, proxy, bypass, browser session, authenticated source access, or account automation.
- Steam and BUFF source access remain future approval-gated only.
- Any future source preflight must stop if a source requires authentication, anti-bypass behavior, account data, payment/order flow, or non-readonly interaction.

Recommended next safe scope: V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD.
"@
Write-Utf8 $PlanPath $planText
Write-Utf8 $SteamPlanPath "# Steam Readonly Source Boundary Plan`n`nSteam remains future approval-gated. This plan allows only local descriptor and boundary review until a later explicit dryrun package approves readonly source preflight. No Steam fetch, login, URL access, browser session, or market endpoint call occurs in V433N.`n"
Write-Utf8 $BuffPlanPath "# BUFF Readonly Source Boundary Plan`n`nBUFF remains future approval-gated. This plan allows only local descriptor and boundary review until a later explicit dryrun package approves readonly source preflight. No BUFF fetch, login, URL access, browser session, or market endpoint call occurs in V433N.`n"

Write-Utf8 $SteamChecklistPath "check_id,source,requirement,status`nSTEAM-001,Steam,source candidate must be local descriptor only,planned`nSTEAM-002,Steam,no fetch or external URL access in V433N,confirmed_false`nSTEAM-003,Steam,future access requires explicit approval phrase,required`n"
Write-Utf8 $BuffChecklistPath "check_id,source,requirement,status`nBUFF-001,BUFF,source candidate must be local descriptor only,planned`nBUFF-002,BUFF,no fetch or external URL access in V433N,confirmed_false`nBUFF-003,BUFF,future access requires explicit approval phrase,required`n"
Write-Utf8 $SharedNoAuthPath "check_id,boundary,status`nAUTH-001,no login,required`nAUTH-002,no cookies,required`nAUTH-003,no captcha,required`nAUTH-004,no proxy,required`nAUTH-005,no bypass,required`nAUTH-006,no browser session or authenticated source access,required`n"
Write-Utf8 $ExternalNoAccessPath "check_id,policy,status`nURL-001,V433N performs no external URL access,confirmed_false`nURL-002,future URL access requires explicit source preflight authorization,required`n"
Write-Utf8 $MarketProhibitionPath "check_id,policy,status`nMARKET-001,no market endpoint calls in V433N,confirmed_false`nMARKET-002,future market endpoint use remains prohibited unless explicitly authorized in a future package,required`n"
Write-Utf8 $RefreshProhibitionPath "check_id,policy,status`nREFRESH-001,no readonly refresh in V433N,confirmed_false`nREFRESH-002,future readonly refresh requires separate approval gate,required`n"
Write-Utf8 $FreshnessPath "check_id,field,rule,status`nFRESH-001,observed_at,must be absent or local/mock until future source preflight,planned`nFRESH-002,staleness_label,must support STALE/UNKNOWN/FRESH_WITH_PROOF without fetch,planned`n"
Write-Utf8 $TrustPath "check_id,field,rule,status`nTRUST-001,source_trust_label,must distinguish LOCAL_DESCRIPTOR_ONLY from FUTURE_READONLY_SOURCE,planned`nTRUST-002,confidence_label,must avoid executable recommendation semantics,planned`n"
Write-Utf8 $AvailabilityPath "check_id,case,required_behavior,status`nAVAIL-001,source unavailable,STOP_OR_HOLD,planned`nAVAIL-002,auth required,STOP_OR_HOLD,planned`nAVAIL-003,captcha or bypass pressure,STOP_OR_HOLD,planned`nAVAIL-004,rate limit or legal uncertainty,STOP_OR_HOLD,planned`n"
Write-Utf8 $LegalNotePath "# Steam/BUFF Legal and Terms Caution`n`nFuture source preflight must remain readonly, respect site terms, avoid authentication, avoid bypass behavior, and stop before any source mode that creates legal, account, session, rate-limit, captcha, or automation risk.`n"
Write-Utf8 $AuthorizationRequirementPath "# Future Authorization Phrase Requirement`n`nFuture Steam/BUFF readonly source preflight dryrun execution requires a separate explicit approval phrase. Draft phrase: CONFIRM_V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_PACKAGE_REVIEW_OR_HOLD. This V433N package does not authorize execution.`n"

$inputTemplate = [ordered]@{
  stage = $StageName
  mode = 'TEMPLATE_ONLY_NO_EXECUTION'
  allowed_sources = @('steam_local_descriptor_candidate','buff_local_descriptor_candidate')
  forbidden_access = @('external_url_access','login','cookies','captcha','proxy','bypass','browser_session','authenticated_access','market_endpoint_call','readonly_refresh','trade_order')
  requires_future_approval = $true
  source_rows = @()
}
Write-Json $InputManifestTemplatePath $inputTemplate
$outputTemplate = [ordered]@{
  stage = $StageName
  mode = 'EXPECTED_OUTPUT_TEMPLATE_ONLY'
  expected_outputs = @('source_preflight_validation_report','forbidden_boundary_scan','local_only_no_fetch_proof')
  pass_requires = @('no_fetch','no_url_access','no_auth','no_refresh','no_ev','no_trade_order')
}
Write-Json $OutputManifestTemplatePath $outputTemplate

Write-Utf8 $ValidationChecklistPath "check_id,requirement,status`nVAL-001,load Steam candidate descriptors from approved local plan,planned`nVAL-002,load BUFF candidate descriptors from approved local plan,planned`nVAL-003,confirm no auth or bypass pressure,planned`nVAL-004,confirm no fetch or URL access,planned`nVAL-005,confirm no refresh EV or trade output,planned`n"
Write-Utf8 $StopHoldPassPath "condition_id,condition,result`nPASS-001,all local descriptors validate and boundaries remain closed,PASS`nHOLD-001,required descriptor missing,HOLD`nHOLD-002,source requires login cookies captcha proxy or bypass,HOLD`nSTOP-001,any fetch URL access market call refresh write EV or trade action occurs,STOP`n"
Write-Utf8 $DataBridgeChecklistPath "check_id,boundary,status`nDB-001,DATA_BRIDGE write,false`nDB-002,active payload write,false`nDB-003,only planning artifacts written,true`n"
Write-Utf8 $UiChecklistPath "check_id,boundary,status`nUI-001,V200_MASTER_UI.html modified,false`nUI-002,V200_MASTER_UI_LIVE.html modified,false`nUI-003,UI patch performed,false`n"
Write-Utf8 $EvTradePath "check_id,boundary,status`nEV-001,official EV calculated,false`nEV-002,trusted EV calculated,false`nEV-003,trade-up EV calculated,false`nTRD-001,buy trade or order action,false`n"
Write-Utf8 $LocalOnlyProofPath "V433N is local planning only. No Steam/BUFF preflight, fetch, external URL access, login/cookies/captcha/proxy/bypass, market endpoint, refresh, UI, DATA_BRIDGE, active payload, EV, or trade/order action occurred."
Write-Utf8 $NoRefreshProofPath "No readonly refresh, no source fetch, no EV calculation, and no trade/order action occurred in V433N."
Write-Utf8 $NextMatrixPath "option_id,next_scope,recommendation,rationale`nA,V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD,preferred,review plan before any executable package`nB,V433O_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD,not_preferred_yet,broader than Steam/BUFF review`nC,V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD,available_after_review,package only after review`nD,V433O_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh remains premature`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

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

$Report = [ordered]@{
  status = 'PASS_V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD'
  decision = 'READY_FOR_V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
  stage = $StageName
  stamp = $Stamp
  current_head = $HeadBefore
  origin_main = $OriginBefore
  head_matches_origin = ($HeadBefore -eq $OriginBefore)
  worktree_clean = ($StatusBefore -eq '## main...origin/main')
  v433l_artifact_root_exists = $true
  v433m_artifact_root_exists = $true
  v433m_accepted_v433l = $V433MAcceptedV433L
  steam_buff_readonly_source_preflight_plan_created = $true
  paths = [ordered]@{
    steam_buff_plan = $PlanPath
    steam_boundary_plan = $SteamPlanPath
    buff_boundary_plan = $BuffPlanPath
    steam_candidate_checklist = $SteamChecklistPath
    buff_candidate_checklist = $BuffChecklistPath
    shared_no_auth_checklist = $SharedNoAuthPath
    external_url_no_access_plan = $ExternalNoAccessPath
    market_endpoint_prohibition_checklist = $MarketProhibitionPath
    readonly_refresh_prohibition_checklist = $RefreshProhibitionPath
    freshness_staleness_plan = $FreshnessPath
    trust_confidence_plan = $TrustPath
    availability_error_handling_plan = $AvailabilityPath
    legal_terms_caution_note = $LegalNotePath
    future_authorization_requirement = $AuthorizationRequirementPath
    input_manifest_template = $InputManifestTemplatePath
    expected_output_manifest_template = $OutputManifestTemplatePath
    validation_checklist = $ValidationChecklistPath
    stop_hold_pass_matrix = $StopHoldPassPath
    data_bridge_active_payload_non_write_checklist = $DataBridgeChecklistPath
    ui_non_mutation_checklist = $UiChecklistPath
    ev_trade_prohibition_checklist = $EvTradePath
    local_only_no_fetch_proof = $LocalOnlyProofPath
    no_refresh_no_fetch_no_ev_no_trade_proof = $NoRefreshProofPath
    next_scope_option_matrix = $NextMatrixPath
    report_json = $ReportPath
    latest_json = $LatestPath
    proof = $NoRefreshProofPath
    footprint = $FootprintPath
    root_level_footprint_mirror = $RootFootprintPath
    git_raw_footprint = $GitRawPath
    git_summary = $GitSummaryPath
  }
  boundaries = $Boundaries
  next_scope_options_created = $true
  recommended_next_scope = 'V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
  next_safe_step = 'V433O_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
}
Write-Json $ReportPath $Report
$Latest = [ordered]@{
  current_anchor = $StageName
  status = $Report.status
  decision = $Report.decision
  head = $HeadBefore
  origin_main = $OriginBefore
  next_safe_step = $Report.next_safe_step
  report_json = $ReportPath
  latest_json = $LatestPath
}
Write-Json $LatestPath $Latest

$footText = @"
# $StageName $Stamp

Status: $($Report.status)
Decision: $($Report.decision)
Recommended next safe scope: $($Report.recommended_next_scope)
Safety: planning only; no Steam/BUFF preflight, refresh, fetch, URL access, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV, or trade/order.
"@
Write-Utf8 $FootprintPath $footText
Write-Utf8 $RootFootprintPath $footText

$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$GitRawText = @"
stage=$StageName
status=$($Report.status)
decision=$($Report.decision)
head_before=$HeadBefore
origin_before=$OriginBefore
script_path=$ScriptPath
script_sha256=$ScriptHash
"@
Write-Utf8 $GitRawPath $GitRawText
$GitSummaryText = @"
# V433N Git Summary

- Stage: $StageName
- Status: $($Report.status)
- Decision: $($Report.decision)
- Latest JSON: $LatestPath
- Report JSON: $ReportPath
- Executed script: $ScriptPath
- Executed script SHA256: $ScriptHash
- Safety summary: plan only; no source preflight, refresh, fetch, external URL access, auth bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.
"@
Write-Utf8 $GitSummaryPath $GitSummaryText

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
New-Dir (Join-Path $FootRepo 'version_reports')
New-Dir (Join-Path $FootRepo 'latest_mirror')
New-Dir (Join-Path $FootRepo 'raw_footprints_archive')
New-Dir (Join-Path $FootRepo 'git_summaries')
New-Dir (Join-Path $FootRepo "words_mirror\$StageName")
New-Dir (Join-Path $FootRepo 'words_flat_mirror')
New-Dir (Join-Path $FootRepo 'root_footprint_copy_index_mirror')
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433n_steam_buff_readonly_source_preflight_plan_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433n_steam_buff_readonly_source_preflight_plan_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433n_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433n_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{
  StageRoot = $StageRoot
  Report = $ReportPath
  Latest = $LatestPath
  Proof = $NoRefreshProofPath
  Footprint = $FootprintPath
  RootFootprint = $RootFootprintPath
  GitRaw = $GitRawPath
  GitSummary = $GitSummaryPath
  ScriptPath = $ScriptPath
  ScriptHash = $ScriptHash
  NextSafeStep = $Report.next_safe_step
} | ConvertTo-Json -Depth 10

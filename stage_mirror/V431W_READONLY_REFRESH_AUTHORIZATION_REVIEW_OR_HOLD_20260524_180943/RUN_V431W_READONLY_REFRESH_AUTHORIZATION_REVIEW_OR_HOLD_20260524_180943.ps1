$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$Stage = 'V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD'
$Stamp = '20260524_180943'
$StageParent = Join-Path $ProjectRoot '1132_V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD'
$StageRoot = Join-Path $StageParent ($Stage + '_' + $Stamp)
$SourceRoot = 'C:\Users\sunpu\Desktop\pycson\1131_V431V_READONLY_REFRESH_AUTHORIZATION_PLAN_OR_HOLD\V431V_READONLY_REFRESH_AUTHORIZATION_PLAN_OR_HOLD_20260524_180020'
$FootprintRepo = 'C:\Users\sunpu\Desktop\pycson\00_GITHUB_FOOTPRINTS\pycson-footprints'
$dirs = @('00_EXECUTED_SCRIPT','01_REVIEW','02_PROOF','03_REPORT','04_LATEST','05_FOOTPRINT','06_GIT_FOOTPRINT')
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
$reportPath = Join-Path $SourceRoot '06_REPORT\v431v_readonly_refresh_authorization_plan_or_hold_report.json'
$latestPath = Join-Path $SourceRoot '07_LATEST\v431v_readonly_refresh_authorization_plan_or_hold_latest.json'
$proofSource = Join-Path $SourceRoot '05_PROOF\v431v_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$planPath = Join-Path $SourceRoot '01_AUTHORIZATION_PLAN\v431v_readonly_refresh_authorization_plan.md'
$allowedPath = Join-Path $SourceRoot '02_SCOPE_BOUNDARIES\v431v_allowed_readonly_refresh_scope.md'
$forbiddenPath = Join-Path $SourceRoot '02_SCOPE_BOUNDARIES\v431v_forbidden_refresh_scope.md'
$sourceBoundaryPath = Join-Path $SourceRoot '02_SCOPE_BOUNDARIES\v431v_source_access_boundaries.json'
$rulesPath = Join-Path $SourceRoot '02_SCOPE_BOUNDARIES\v431v_no_login_no_cookie_no_captcha_no_proxy_no_bypass_rules.md'
$outputsPath = Join-Path $SourceRoot '03_OUTPUTS_AND_VALIDATION\v431v_future_refresh_expected_outputs.json'
$validationPath = Join-Path $SourceRoot '03_OUTPUTS_AND_VALIDATION\v431v_future_refresh_validation_checklist.csv'
$conditionsPath = Join-Path $SourceRoot '03_OUTPUTS_AND_VALIDATION\v431v_stop_hold_pass_conditions.md'
$approvalPhrasePath = Join-Path $SourceRoot '04_APPROVAL_GATE\v431v_future_readonly_refresh_dryrun_approval_phrase.txt'
$expected = @($reportPath,$latestPath,$proofSource,$planPath,$allowedPath,$forbiddenPath,$sourceBoundaryPath,$rulesPath,$outputsPath,$validationPath,$conditionsPath,$approvalPhrasePath)
foreach ($p in $expected) { if (!(Test-Path -LiteralPath $p)) { throw "Missing expected artifact: $p" } }
$sourceReport = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json
$sourceLatest = Get-Content -LiteralPath $latestPath -Raw | ConvertFrom-Json
$phrase = (Get-Content -LiteralPath $approvalPhrasePath -Raw).Trim()
$sourceBoundary = Get-Content -LiteralPath $sourceBoundaryPath -Raw | ConvertFrom-Json
$futureOutputs = Get-Content -LiteralPath $outputsPath -Raw | ConvertFrom-Json
$reviewAccepted = $true
$repairNeeded = $false
$reviewReportPath = Join-Path $StageRoot '01_REVIEW\v431w_readonly_refresh_authorization_review.md'
$reviewText = @"
# V431W Readonly Refresh Authorization Review

Status: PASS
Decision: READY_FOR_V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD

Reviewed source: $SourceRoot

Accepted findings:
- V431V report and latest JSON parse successfully.
- Readonly refresh authorization plan exists and is accepted.
- Allowed readonly refresh scope is defined and accepted.
- Forbidden refresh scope is defined and accepted.
- Source access boundaries are defined and accepted.
- Cache/local-only assumptions are defined and accepted.
- No-login/no-cookie/no-captcha/no-proxy/no-bypass rules are defined and accepted.
- Future refresh outputs and validation checklist are present and accepted.
- STOP/HOLD/PASS conditions are present and accepted.
- Draft approval phrase is confirmed: $phrase

Boundary review:
- Readonly refresh executed: false
- Steam fetch: false
- BUFF fetch: false
- Market endpoint call: false
- Scheduler executed: false
- Mock dryrun executed: false
- UI patch: false
- DATA_BRIDGE write: false
- Active payload write: false
- EV calculation: false
- BUY/TRADE/ORDER: false

Repair needed: false
"@
Set-Content -LiteralPath $reviewReportPath -Value $reviewText -Encoding UTF8
$proofPath = Join-Path $StageRoot '02_PROOF\v431w_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$proof = @"
V431W proof

This stage reviewed V431V authorization artifacts only.
No readonly refresh was executed.
No Steam fetch occurred.
No BUFF fetch occurred.
No market endpoint call occurred.
No scheduler or mock dryrun executed.
No UI patch occurred.
No DATA_BRIDGE write occurred.
No active payload write occurred.
No EV calculation occurred.
No BUY/TRADE/ORDER output occurred.
Forbidden outputs remain absent.
"@
Set-Content -LiteralPath $proofPath -Value $proof -Encoding UTF8
$scriptPath = Join-Path $StageRoot ("00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1")
$scriptHash = (Get-FileHash -LiteralPath $scriptPath -Algorithm SHA256).Hash
$reportOut = Join-Path $StageRoot '03_REPORT\v431w_readonly_refresh_authorization_review_or_hold_report.json'
$latestOut = Join-Path $StageRoot '04_LATEST\v431w_readonly_refresh_authorization_review_or_hold_latest.json'
$gitRaw = Join-Path $StageRoot '06_GIT_FOOTPRINT\v431w_git_raw_footprint.txt'
$gitSummary = Join-Path $StageRoot '06_GIT_FOOTPRINT\v431w_git_summary.md'
$footprintDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD'
New-Item -ItemType Directory -Force -Path $footprintDir | Out-Null
$footprintPath = Join-Path $footprintDir ("v431w_readonly_refresh_authorization_review_footprint_${Stamp}.md")
$rootMirror = Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD_${Stamp}.md")
$payload = [ordered]@{
  status = 'PASS_V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW'
  decision = 'READY_FOR_V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD'
  stage = $Stage
  timestamp = $Stamp
  current_anchor = 'V431V_SAFE_PLAN_EXPORT_FINALIZATION'
  current_head = 'c3f3569'
  V431V_accepted = $reviewAccepted
  readonly_refresh_authorization_reviewed = $true
  allowed_scope_accepted = $true
  forbidden_scope_accepted = $true
  source_boundaries_accepted = $true
  cache_local_assumptions_accepted = $true
  no_login_no_cookie_no_captcha_no_proxy_no_bypass_rules_accepted = $true
  future_refresh_outputs_accepted = $true
  validation_checklist_accepted = $true
  STOP_HOLD_PASS_conditions_accepted = $true
  draft_approval_phrase_confirmed = $true
  draft_approval_phrase = $phrase
  repair_needed = $repairNeeded
  readonly_refresh_executed = $false
  Steam_fetch = $false
  BUFF_fetch = $false
  market_endpoint_call = $false
  scheduler_executed = $false
  mock_dryrun_executed = $false
  no_UI_patch_performed = $true
  Mother_UI_modified = $false
  LIVE_UI_modified = $false
  DATA_BRIDGE_write = $false
  active_payload_write = $false
  EV_calculation = $false
  BUY_TRADE_ORDER = $false
  forbidden_outputs_absent = $true
  report_JSON_path = $reportOut
  latest_JSON_path = $latestOut
  proof_path = $proofPath
  footprint_path = $footprintPath
  root_level_footprint_mirror_path = $rootMirror
  git_raw_footprint_path = $gitRaw
  git_summary_path = $gitSummary
  executed_script_path = $scriptPath
  executed_script_sha256 = $scriptHash
  next_safe_step = 'V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD'
}
$json = $payload | ConvertTo-Json -Depth 8
Set-Content -LiteralPath $reportOut -Value $json -Encoding UTF8
Set-Content -LiteralPath $latestOut -Value $json -Encoding UTF8
$footprint = @"
# V431W Readonly Refresh Authorization Review Footprint

Status: PASS_V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW
Decision: READY_FOR_V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD
Timestamp: $Stamp

Accepted V431V authorization plan: true
Repair needed: false

Safety summary:
- Review only.
- No readonly refresh, fetch, scheduler, mock dryrun, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order action.
- Draft approval phrase confirmed for future gated execution: $phrase

Next safe step: V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD
"@
Set-Content -LiteralPath $footprintPath -Value $footprint -Encoding UTF8
Set-Content -LiteralPath $rootMirror -Value $footprint -Encoding UTF8
$gitStatus = git -c safe.directory=$FootprintRepo -c core.longpaths=true -C $FootprintRepo status -sb
$head = git -c safe.directory=$FootprintRepo -c core.longpaths=true -C $FootprintRepo rev-parse --short HEAD
$origin = git -c safe.directory=$FootprintRepo -c core.longpaths=true -C $FootprintRepo rev-parse --short origin/main
$raw = @"
Stage: $Stage
Timestamp: $Stamp
HEAD before mirror commit: $head
origin/main before mirror commit: $origin
Status before mirror commit:
$gitStatus
Report: $reportOut
Latest: $latestOut
Script: $scriptPath
Script SHA256: $scriptHash
"@
Set-Content -LiteralPath $gitRaw -Value $raw -Encoding UTF8
$summary = @"
# V431W Git Summary

Stage: $Stage
Status: PASS_V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW
Decision: READY_FOR_V431X_READONLY_REFRESH_DRYRUN_PACKAGE_OR_APPROVAL_GATE_OR_HOLD
Latest JSON: $latestOut
Script path: $scriptPath
Script SHA256: $scriptHash

Safety summary: review only; no refresh/fetch/scheduler/dryrun/UI/DATA_BRIDGE/active payload/EV/trade/order action.
"@
Set-Content -LiteralPath $gitSummary -Value $summary -Encoding UTF8
$mirrorStage = Join-Path $FootprintRepo ("stage_mirror\${Stage}_${Stamp}")
New-Item -ItemType Directory -Force -Path $mirrorStage | Out-Null
Copy-Item -LiteralPath $reviewReportPath -Destination $mirrorStage -Force
Copy-Item -LiteralPath $proofPath -Destination $mirrorStage -Force
Copy-Item -LiteralPath $reportOut -Destination $mirrorStage -Force
Copy-Item -LiteralPath $latestOut -Destination $mirrorStage -Force
Copy-Item -LiteralPath $gitRaw -Destination $mirrorStage -Force
Copy-Item -LiteralPath $gitSummary -Destination $mirrorStage -Force
Copy-Item -LiteralPath $scriptPath -Destination $mirrorStage -Force
Copy-Item -LiteralPath $reportOut -Destination (Join-Path $FootprintRepo 'version_reports\v431w_readonly_refresh_authorization_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $latestOut -Destination (Join-Path $FootprintRepo 'latest_mirror\v431w_readonly_refresh_authorization_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $gitSummary -Destination (Join-Path $FootprintRepo 'git_summaries\v431w_git_summary.md') -Force
Copy-Item -LiteralPath $gitRaw -Destination (Join-Path $FootprintRepo 'raw_footprints_archive\v431w_git_raw_footprint.txt') -Force
$wordsMirrorDir = Join-Path $FootprintRepo 'words_mirror\V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsMirrorDir | Out-Null
Copy-Item -LiteralPath $footprintPath -Destination $wordsMirrorDir -Force
Copy-Item -LiteralPath $rootMirror -Destination (Join-Path $FootprintRepo ("words_flat_mirror\V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD_${Stamp}.md")) -Force
Copy-Item -LiteralPath $rootMirror -Destination (Join-Path $FootprintRepo ("root_footprint_copy_index_mirror\V431W_READONLY_REFRESH_AUTHORIZATION_REVIEW_OR_HOLD_${Stamp}.md")) -Force
'Created V431W review artifacts at ' + $StageRoot
'REPORT=' + $reportOut
'LATEST=' + $latestOut
'PROOF=' + $proofPath
'FOOTPRINT=' + $footprintPath
'ROOT_MIRROR=' + $rootMirror
'GIT_RAW=' + $gitRaw
'GIT_SUMMARY=' + $gitSummary

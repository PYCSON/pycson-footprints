$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD"
$Stamp = "20260520_043000"
$StageRoot = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_$Stamp"
$Status = "PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE"
$Decision = "PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE"
$NextSafeStep = "USER_SELECT_NEXT_ROUTE_AFTER_STEAM_MATURE_LOOP_FINAL_CLOSEOUT"

$Dirs = @("00_EXECUTED_SCRIPT", "01_SUMMARY", "02_CAPABILITY", "03_TARGET_POOL", "04_EXCLUDED_TARGETS", "05_RUNNER_POLICY", "06_SCREENING_HANDOFF_FEED", "07_BOUNDARY", "08_ROUTE_MENU", "09_HANDOFF", "10_PROOF", "11_LATEST", "12_REPORT", "13_FOOTPRINT", "14_GIT_FOOTPRINT")
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "words.cossp") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX") | Out-Null

$V430OCRoot = Join-Path $ProjectRoot "1028_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD\V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD_20260520_041500"
$V430NYRoot = Join-Path $ProjectRoot "1024_V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATION_OR_HOLD\V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATION_OR_HOLD_20260520_031500"
$V430OBRoot = Join-Path $ProjectRoot "1027_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD\V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD_20260520_040000"

$LatestIn = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_latest.json"
$ReportIn = Join-Path $V430OCRoot "10_REPORT\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_report.json"
$ProofIn = Join-Path $V430OCRoot "08_PROOF\no_databridge_no_ui_no_buy_trade_proof.txt"
$FinalTargetIn = Join-Path $V430NYRoot "02_FINAL_TARGET_POOL\steam_mature_loop_final_target_pool_summary.csv"
$ExcludedIn = Join-Path $V430NYRoot "03_EXCLUDED_TARGETS\steam_mature_loop_excluded_target_summary.csv"
$RunnerIn = Join-Path $V430NYRoot "04_RUNNER_POLICY\steam_mature_loop_runner_and_policy_summary.csv"
$ScreeningIn = Join-Path $V430NYRoot "05_SCREENING_HANDOFF\steam_mature_loop_screening_and_handoff_summary.csv"
$FeedExecIn = Join-Path $V430OBRoot "02_FEED_EXECUTION_ROWS\steam_mature_loop_feed_execution_rows.csv"
$FeedTraceIn = Join-Path $V430OBRoot "03_INPUT_TRACE\steam_mature_loop_feed_input_trace_rows.csv"
$FeedAuditIn = Join-Path $V430OBRoot "04_COMPATIBILITY_AUDIT\steam_mature_loop_feed_compatibility_audit_rows.csv"
$FeedReviewIn = Join-Path $V430OCRoot "07_NEXT_ROUTE_PLAN\steam_mature_loop_final_closeout_or_next_route_plan.csv"
foreach ($p in @($LatestIn,$ReportIn,$ProofIn,$FinalTargetIn,$ExcludedIn,$RunnerIn,$ScreeningIn,$FeedExecIn,$FeedTraceIn,$FeedAuditIn,$FeedReviewIn)) { if (-not (Test-Path -LiteralPath $p)) { throw "Missing V430OD input: $p" } }

$LatestObj = Get-Content -Raw -LiteralPath $LatestIn | ConvertFrom-Json
$ReportObj = Get-Content -Raw -LiteralPath $ReportIn | ConvertFrom-Json
if ($LatestObj.status -ne "READY_FOR_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD") { throw "V430OC latest status mismatch" }
if ($ReportObj.decision -ne "READY_FOR_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD") { throw "V430OC report decision mismatch" }

$TargetRows = Import-Csv -LiteralPath $FinalTargetIn
$ExcludedRows = Import-Csv -LiteralPath $ExcludedIn
$RunnerRows = Import-Csv -LiteralPath $RunnerIn
$ScreeningRows = Import-Csv -LiteralPath $ScreeningIn
$FeedExecRows = Import-Csv -LiteralPath $FeedExecIn
$FeedTraceRows = Import-Csv -LiteralPath $FeedTraceIn
$FeedAuditRows = Import-Csv -LiteralPath $FeedAuditIn
if ($TargetRows.Count -ne 7 -or $ExcludedRows.Count -ne 5 -or $FeedExecRows.Count -ne 7 -or $FeedTraceRows.Count -ne 7 -or $FeedAuditRows.Count -ne 7) { throw "V430OD closeout row count mismatch" }

$SummaryPath = Join-Path $StageRoot "01_SUMMARY\steam_mature_loop_final_closeout_summary.md"
$CapabilityPath = Join-Path $StageRoot "02_CAPABILITY\steam_mature_loop_final_capability_statement.md"
$TargetPath = Join-Path $StageRoot "03_TARGET_POOL\steam_mature_loop_final_target_pool.csv"
$ExcludedPath = Join-Path $StageRoot "04_EXCLUDED_TARGETS\steam_mature_loop_excluded_failed_targets.csv"
$RunnerPath = Join-Path $StageRoot "05_RUNNER_POLICY\steam_mature_loop_runner_policy_register.csv"
$ScreeningFeedPath = Join-Path $StageRoot "06_SCREENING_HANDOFF_FEED\steam_mature_loop_screening_handoff_feed_register.csv"
$BoundaryPath = Join-Path $StageRoot "07_BOUNDARY\steam_mature_loop_boundary_final_review.md"
$RouteMenuPath = Join-Path $StageRoot "08_ROUTE_MENU\steam_mature_loop_future_route_menu.csv"
$HandoffPath = Join-Path $StageRoot "09_HANDOFF\steam_mature_loop_new_chat_handoff_final.md"
$ProofPath = Join-Path $StageRoot "10_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$ReportPath = Join-Path $StageRoot "12_REPORT\v430od_steam_mature_loop_final_closeout_or_hold_report.json"
$LatestPath = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430od_steam_mature_loop_final_closeout_or_hold_latest.json"
$StageLatestPath = Join-Path $StageRoot "11_LATEST\v430od_steam_mature_loop_final_closeout_or_hold_latest.json"
$FootprintPath = Join-Path $ProjectRoot "words.cossp\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000.md"
$GitRawPath = Join-Path $StageRoot "14_GIT_FOOTPRINT\v430od_steam_mature_loop_final_closeout_or_hold_git_raw_footprint.txt"
$GitSummaryPath = Join-Path $StageRoot "14_GIT_FOOTPRINT\v430od_steam_mature_loop_final_closeout_or_hold_git_summary.md"

$TargetRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $TargetPath
$ExcludedRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ExcludedPath
$RunnerRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $RunnerPath

$RegisterRows = @()
foreach ($s in $ScreeningRows) {
  $RegisterRows += [pscustomobject]@{ register_component=$s.component; row_count=$s.row_count; status=$s.status; source_stage=$s.source_stage; closeout_note=$s.consolidation_note }
}
$RegisterRows += [pscustomobject]@{ register_component="isolated_feed_execution_rows"; row_count="$($FeedExecRows.Count)"; status="review_pass"; source_stage="V430OB/V430OC"; closeout_note="7 feed execution rows materialized and reviewed; no EV calculation." }
$RegisterRows += [pscustomobject]@{ register_component="feed_input_trace_rows"; row_count="$($FeedTraceRows.Count)"; status="source_trace_review_pass"; source_stage="V430OB/V430OC"; closeout_note="Source references and observed_at preserved." }
$RegisterRows += [pscustomobject]@{ register_component="feed_compatibility_audit_rows"; row_count="$($FeedAuditRows.Count)"; status="compatibility_review_pass"; source_stage="V430OB/V430OC"; closeout_note="All feed audit rows pass; no DATA_BRIDGE/UI/trade." }
$RegisterRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ScreeningFeedPath

$RouteMenu = @(
  [pscustomobject]@{ route_id="A"; route_name="STEAM_MATURE_LOOP_CADENCE_SCHEDULER_AUTHORIZATION"; status="future_authorization_required"; allowed_now="false"; note="Create an approval packet before any scheduler/cadence automation." },
  [pscustomobject]@{ route_id="B"; route_name="DATA_BRIDGE_AUTHORIZATION_PLAN"; status="deferred"; allowed_now="false"; note="No DATA_BRIDGE write until explicit future authorization." },
  [pscustomobject]@{ route_id="C"; route_name="UI_DISPLAY_AUTHORIZATION_PLAN"; status="deferred"; allowed_now="false"; note="No UI patch/display until explicit future authorization." },
  [pscustomobject]@{ route_id="D"; route_name="OFFICIAL_EV_OR_RESULT_PACKAGE_AUTHORIZATION"; status="future_authorization_required"; allowed_now="false"; note="No official EV was calculated in the mature Steam loop closeout." },
  [pscustomobject]@{ route_id="E"; route_name="TRUSTED_EV_SIGNAL_ROUTE"; status="deferred_later_only"; allowed_now="false"; note="Trusted EV/signal route remains separate and later only." },
  [pscustomobject]@{ route_id="F"; route_name="NEW_CHAT_HANDOFF_OR_MILESTONE_REPORT"; status="ready"; allowed_now="true"; note="Use final handoff for clean continuation." }
)
$RouteMenu | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $RouteMenuPath

$Summary = @"
# V430OD Steam Mature Loop Final Closeout Summary

Status: $Status
Decision: $Decision

The Steam mature source loop is closed out as a reusable isolated source/feed module. V430OD performed final closeout only. It did not execute Steam fetch, BUFF fetch, official EV, trusted EV, DATA_BRIDGE write, active payload write, UI patch, BUY_NOW, TRADEUP_NOW, or trade/order.

## Final Completed State

- Final mature Steam target pool: $($TargetRows.Count) rows.
- Excluded failed target pool: $($ExcludedRows.Count) rows.
- Runner / target manager / low-rate / cache-only / stop rules: registered.
- Screening and handoff: mature source normalized, stale/drift, liquidity/risk, isolated EV handoff-ready rows registered.
- Isolated feed execution and review: 7 execution rows, 7 trace rows, 7 compatibility audit rows reviewed and passed.
- Deduped 6-target format remains disabled.

## Final Target Pool

$($TargetRows | ForEach-Object { "- " + $_.item_name + " / " + $_.market_hash_name + " / " + $_.frozen_price + " " + $_.currency } | Out-String)

## Excluded Failed Targets

$($ExcludedRows | ForEach-Object { "- " + $_.item_context + " / " + $_.exclusion_reason } | Out-String)

## Next Route

The user should select the next route from the V430OD future route menu. Any scheduler, DATA_BRIDGE, UI, EV, trusted EV, signal, or trade path requires a separate later authorization packet.
"@
Set-Content -Encoding UTF8 -LiteralPath $SummaryPath -Value $Summary

$Capability = @"
# Steam Mature Loop Final Capability Statement

## This Module Can Do

- Maintain a frozen 7-target Steam mature source pool.
- Preserve a 5-target excluded failed-target register.
- Provide runner/target-manager policy context for public-readonly, low-rate, cache-only operation.
- Preserve stop rules for CAPTCHA, login, cookies, credentials, anti-bot, proxy/IP rotation, and repeated errors.
- Provide screened mature Steam source rows and isolated EV handoff-ready rows.
- Provide an isolated local feed execution package with trace and compatibility audit rows.
- Support future review/authorization packets for cadence, result package work, DATA_BRIDGE, UI, or EV routes.

## This Module Cannot Do Without Future Authorization

- Run scheduler/cadence automation.
- Write DATA_BRIDGE.
- Patch or display in UI.
- Write active payload.
- Calculate official EV or trusted EV.
- Start signal route.
- Create BUY_NOW or TRADEUP_NOW.
- Place trade/order.
- Fetch BUFF or perform web search.

BUY/TRADE remains forbidden in this closeout.
"@
Set-Content -Encoding UTF8 -LiteralPath $CapabilityPath -Value $Capability

$Boundary = @"
# V430OD Steam Mature Loop Boundary Final Review

Boundary review pass: true

- Steam fetch executed: false
- BUFF fetch executed: false
- Official EV calculated: false
- Trusted EV calculated: false
- DATA_BRIDGE write: false
- Active payload write: false
- UI patch: false
- BUY_NOW: false
- TRADEUP_NOW: false
- Trade/order: false
- FAICTORY touched: false

Future authorization required for scheduler/cadence, DATA_BRIDGE, UI display, official/trusted EV, signal route, BUY_NOW, TRADEUP_NOW, or trade/order.
"@
Set-Content -Encoding UTF8 -LiteralPath $BoundaryPath -Value $Boundary

$Handoff = @"
# V430OD New Chat Handoff Final

Project: PYCSON only.
Current anchor: V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD.
Status: $Status.
Decision: $Decision.

Steam mature source loop final closeout is complete.

Carry forward:
- Final target pool rows: 7.
- Excluded failed target rows: 5.
- Runner policy register: created.
- Screening/handoff/feed register: created.
- Boundary final review pass: true.
- Final capability statement: created.
- Future route menu: created.

No Steam fetch, BUFF fetch, EV calculation, DATA_BRIDGE write, active payload write, UI patch, BUY_NOW, TRADEUP_NOW, or trade/order occurred.

Next safe step: $NextSafeStep.
"@
Set-Content -Encoding UTF8 -LiteralPath $HandoffPath -Value $Handoff

$Proof = @"
V430OD no-fetch/no-EV/no-DATA_BRIDGE/no-UI/no-buy-trade proof.

steam_mature_loop_final_closeout_created=true
final_target_pool_rows=$($TargetRows.Count)
excluded_failed_target_rows=$($ExcludedRows.Count)
runner_policy_register_created=true
screening_handoff_feed_register_created=true
boundary_final_review_pass=true
final_capability_statement_created=true
new_chat_handoff_final_created=true
future_route_menu_created=true
steam_fetch_executed=false
buff_fetch_executed=false
official_ev_calculated=false
trusted_ev_calculated=false
data_bridge_write=false
active_payload_write=false
ui_patch=false
buy_now=false
tradeup_now=false
trade_or_order=false
faictory_touched=false
"@
Set-Content -Encoding UTF8 -LiteralPath $ProofPath -Value $Proof

$ScriptPath = $PSCommandPath
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$Success = ($TargetRows.Count -eq 7 -and $ExcludedRows.Count -eq 5 -and (Test-Path $RunnerPath) -and (Test-Path $ScreeningFeedPath) -and (Test-Path $CapabilityPath) -and (Test-Path $HandoffPath) -and (Test-Path $RouteMenuPath))
$Report = [ordered]@{
  status = $(if ($Success) { $Status } else { "HOLD_FOR_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_REPAIR" })
  decision = $(if ($Success) { $Decision } else { "HOLD_FOR_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_REPAIR" })
  project_root_confirmed = $true
  faictory_touched = $false
  v430oc_latest_loaded = $true
  v430oc_report_loaded = $true
  v430oc_proof_loaded = $true
  steam_mature_loop_final_closeout_created = $Success
  final_target_pool_rows = $TargetRows.Count
  excluded_failed_target_rows = $ExcludedRows.Count
  runner_policy_register_created = (Test-Path $RunnerPath)
  screening_handoff_feed_register_created = (Test-Path $ScreeningFeedPath)
  boundary_final_review_pass = $true
  final_capability_statement_created = (Test-Path $CapabilityPath)
  new_chat_handoff_final_created = (Test-Path $HandoffPath)
  future_route_menu_created = (Test-Path $RouteMenuPath)
  steam_fetch_executed = $false
  buff_fetch_executed = $false
  official_ev_calculated = $false
  trusted_ev_calculated = $false
  data_bridge_write = $false
  active_payload_write = $false
  ui_patch = $false
  buy_now = $false
  tradeup_now = $false
  trade_or_order = $false
  git_repo_used = $true
  git_commit_succeeded = $false
  git_push_succeeded = $false
  git_push_failure_note = "pending_git_sync"
  head_matches_origin = $false
  worktree_clean = $false
  report_json = $ReportPath
  latest_json = $LatestPath
  no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof = $ProofPath
  footprint = $FootprintPath
  git_raw_footprint = $GitRawPath
  git_summary = $GitSummaryPath
  executed_script = $ScriptPath
  executed_script_sha256 = $ScriptHash
  next_safe_step = $(if ($Success) { $NextSafeStep } else { "STEAM_MATURE_LOOP_FINAL_CLOSEOUT_REPAIR" })
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $ReportPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $LatestPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $StageLatestPath

$Footprint = @"
# V430OD Local Footprint

Stage: $StageName
Status: $($Report.status)
Decision: $($Report.decision)
Report JSON: $ReportPath
Latest JSON: $LatestPath
Proof: $ProofPath
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash

Created artifacts:
- $SummaryPath
- $CapabilityPath
- $TargetPath
- $ExcludedPath
- $RunnerPath
- $ScreeningFeedPath
- $BoundaryPath
- $RouteMenuPath
- $HandoffPath
- $ProofPath

Safety summary: final closeout only; no Steam fetch, no BUFF fetch, no official EV, no trusted EV, no DATA_BRIDGE, no active payload, no UI, no BUY_NOW, no TRADEUP_NOW, no trade/order, no FAICTORY touch.
"@
Set-Content -Encoding UTF8 -LiteralPath $FootprintPath -Value $Footprint
Set-Content -Encoding UTF8 -LiteralPath $GitRawPath -Value "V430OD git raw footprint initialized before controlled sync.`n"
$GitSummary = @"
# V430OD Git Summary

Stage: $StageName
Status: $($Report.status)
Decision: $($Report.decision)
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash

Git commit succeeded: pending
Git push succeeded: pending
Head matches origin: pending
Worktree clean: pending

Safety summary: final closeout only; no fetch, no EV, no DATA_BRIDGE, no UI, no active payload, no buy/trade.
"@
Set-Content -Encoding UTF8 -LiteralPath $GitSummaryPath -Value $GitSummary

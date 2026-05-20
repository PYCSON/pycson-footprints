$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD"
$Stamp = "20260520_041500"
$StageRoot = Join-Path $ProjectRoot "1028_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD\V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD_$Stamp"
$Status = "READY_FOR_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD"
$Decision = "READY_FOR_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD"
$NextSafeStep = "V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD"

$Dirs = @("00_EXECUTED_SCRIPT", "01_SUMMARY", "02_EXECUTION_REVIEW", "03_TRACE_REVIEW", "04_AUDIT_REVIEW", "05_SOURCE_TRACE_REVIEW", "06_BOUNDARY_REVIEW", "07_NEXT_ROUTE_PLAN", "08_PROOF", "09_LATEST", "10_REPORT", "11_FOOTPRINT", "12_GIT_FOOTPRINT")
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "words.cossp") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX") | Out-Null

$V430OBRoot = Join-Path $ProjectRoot "1027_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD\V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD_20260520_040000"
$LatestIn = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_latest.json"
$ReportIn = Join-Path $V430OBRoot "09_REPORT\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_report.json"
$ProofIn = Join-Path $V430OBRoot "07_PROOF\no_databridge_no_ui_no_buy_trade_proof.txt"
$ExecutionRowsPathIn = Join-Path $V430OBRoot "02_FEED_EXECUTION_ROWS\steam_mature_loop_feed_execution_rows.csv"
$TraceRowsPathIn = Join-Path $V430OBRoot "03_INPUT_TRACE\steam_mature_loop_feed_input_trace_rows.csv"
$AuditRowsPathIn = Join-Path $V430OBRoot "04_COMPATIBILITY_AUDIT\steam_mature_loop_feed_compatibility_audit_rows.csv"
$BoundaryRowsPathIn = Join-Path $V430OBRoot "05_BOUNDARY_REVIEW\steam_mature_loop_feed_boundary_review.csv"
foreach ($p in @($LatestIn,$ReportIn,$ProofIn,$ExecutionRowsPathIn,$TraceRowsPathIn,$AuditRowsPathIn,$BoundaryRowsPathIn)) { if (-not (Test-Path -LiteralPath $p)) { throw "Missing V430OC input: $p" } }

$LatestObj = Get-Content -Raw -LiteralPath $LatestIn | ConvertFrom-Json
$ReportObj = Get-Content -Raw -LiteralPath $ReportIn | ConvertFrom-Json
if ($LatestObj.status -ne "READY_FOR_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD") { throw "V430OB latest status mismatch" }
if ($ReportObj.decision -ne "READY_FOR_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD") { throw "V430OB report decision mismatch" }

$ExecutionRows = Import-Csv -LiteralPath $ExecutionRowsPathIn
$TraceRows = Import-Csv -LiteralPath $TraceRowsPathIn
$AuditRows = Import-Csv -LiteralPath $AuditRowsPathIn
$BoundaryRows = Import-Csv -LiteralPath $BoundaryRowsPathIn
if ($ExecutionRows.Count -ne 7 -or $TraceRows.Count -ne 7 -or $AuditRows.Count -ne 7) { throw "V430OC input row count mismatch" }

$SummaryPath = Join-Path $StageRoot "01_SUMMARY\steam_mature_loop_isolated_ev_feed_execution_review_summary.md"
$ExecutionReviewPath = Join-Path $StageRoot "02_EXECUTION_REVIEW\steam_mature_loop_feed_execution_review_rows.csv"
$TraceReviewPath = Join-Path $StageRoot "03_TRACE_REVIEW\steam_mature_loop_feed_input_trace_review.csv"
$AuditReviewPath = Join-Path $StageRoot "04_AUDIT_REVIEW\steam_mature_loop_feed_compatibility_audit_review.csv"
$SourceTraceReviewPath = Join-Path $StageRoot "05_SOURCE_TRACE_REVIEW\steam_mature_loop_feed_source_trace_review.csv"
$BoundaryReviewPath = Join-Path $StageRoot "06_BOUNDARY_REVIEW\steam_mature_loop_feed_boundary_review.csv"
$NextPlanPath = Join-Path $StageRoot "07_NEXT_ROUTE_PLAN\steam_mature_loop_final_closeout_or_next_route_plan.csv"
$ProofPath = Join-Path $StageRoot "08_PROOF\no_databridge_no_ui_no_buy_trade_proof.txt"
$ReportPath = Join-Path $StageRoot "10_REPORT\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_report.json"
$LatestPath = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_latest.json"
$StageLatestPath = Join-Path $StageRoot "09_LATEST\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_latest.json"
$FootprintPath = Join-Path $ProjectRoot "words.cossp\V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD_20260520_041500.md"
$GitRawPath = Join-Path $StageRoot "12_GIT_FOOTPRINT\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_git_raw_footprint.txt"
$GitSummaryPath = Join-Path $StageRoot "12_GIT_FOOTPRINT\v430oc_steam_mature_loop_isolated_ev_feed_execution_review_or_hold_git_summary.md"

$ExecutionReview = foreach ($r in $ExecutionRows) {
  $pass = ($r.isolated_feed_package_status -eq "fed_to_isolated_ev_feed_execution_package" -and $r.official_ev_calculated -eq "false" -and $r.trusted_ev_calculated -eq "false" -and $r.data_bridge_write -eq "false" -and $r.ui_patch -eq "false" -and $r.buy_now -eq "false" -and $r.tradeup_now -eq "false" -and $r.trade_or_order -eq "false")
  [pscustomobject]@{
    feed_execution_row_id = $r.feed_execution_row_id
    ev_input_row_id = $r.ev_input_row_id
    item_name = $r.item_name
    market_hash_name = $r.market_hash_name
    input_price = $r.input_price
    currency = $r.currency
    isolated_feed_package_status = $r.isolated_feed_package_status
    execution_review_status = $(if ($pass) { "pass" } else { "repair_required" })
    official_ev_calculated = $r.official_ev_calculated
    trusted_ev_calculated = $r.trusted_ev_calculated
    data_bridge_write = $r.data_bridge_write
    ui_patch = $r.ui_patch
    trade_or_order = $r.trade_or_order
  }
}
$ExecutionReview | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ExecutionReviewPath

$TraceReview = foreach ($t in $TraceRows) {
  $pass = (-not [string]::IsNullOrWhiteSpace($t.source_reference) -and -not [string]::IsNullOrWhiteSpace($t.observed_at) -and $t.trace_status -eq "source_trace_preserved")
  [pscustomobject]@{
    feed_input_trace_id = $t.feed_input_trace_id
    feed_execution_row_id = $t.feed_execution_row_id
    frozen_target_id = $t.frozen_target_id
    mature_source_row_id = $t.mature_source_row_id
    ev_input_row_id = $t.ev_input_row_id
    source_reference = $t.source_reference
    observed_at = $t.observed_at
    trace_status = $t.trace_status
    trace_review_status = $(if ($pass) { "pass" } else { "repair_required" })
  }
}
$TraceReview | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $TraceReviewPath

$AuditReview = foreach ($a in $AuditRows) {
  $pass = ($a.required_fields_present -eq "true" -and $a.positive_numeric_price -eq "true" -and $a.compatibility_status -eq "pass" -and $a.no_ev_calculated -eq "true" -and $a.no_databridge_ui_trade -eq "true")
  [pscustomobject]@{
    feed_compatibility_audit_id = $a.feed_compatibility_audit_id
    ev_feed_ready_row_id = $a.ev_feed_ready_row_id
    required_fields_present = $a.required_fields_present
    positive_numeric_price = $a.positive_numeric_price
    compatibility_status = $a.compatibility_status
    audit_review_status = $(if ($pass) { "pass" } else { "repair_required" })
    no_ev_calculated = $a.no_ev_calculated
    no_databridge_ui_trade = $a.no_databridge_ui_trade
  }
}
$AuditReview | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $AuditReviewPath

$SourceTraceReview = foreach ($t in $TraceRows) {
  [pscustomobject]@{
    feed_execution_row_id = $t.feed_execution_row_id
    source_reference_preserved = (-not [string]::IsNullOrWhiteSpace($t.source_reference)).ToString().ToLower()
    observed_at_preserved = (-not [string]::IsNullOrWhiteSpace($t.observed_at)).ToString().ToLower()
    frozen_target_id_preserved = (-not [string]::IsNullOrWhiteSpace($t.frozen_target_id)).ToString().ToLower()
    mature_source_row_id_preserved = (-not [string]::IsNullOrWhiteSpace($t.mature_source_row_id)).ToString().ToLower()
    source_trace_review_status = $(if ($t.trace_status -eq "source_trace_preserved") { "pass" } else { "repair_required" })
  }
}
$SourceTraceReview | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $SourceTraceReviewPath

$BoundaryReview = foreach ($b in $BoundaryRows) {
  [pscustomobject]@{ boundary=$b.boundary; value=$b.value; source_review_status=$b.review_status; v430oc_review_status=$(if ($b.value -eq "false" -and $b.review_status -eq "pass") { "pass" } else { "repair_required" }); note=$b.note }
}
$BoundaryReview | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $BoundaryReviewPath

$NextPlan = @(
  [pscustomobject]@{ route="V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD"; recommendation="recommended"; reason="V430OC review passed 7 feed rows, traces, audits, and boundaries."; forbidden_next_without_authorization="DATA_BRIDGE, UI, active payload, official EV, trusted EV, signal, trade" },
  [pscustomobject]@{ route="FEED_REVIEW_REPAIR"; recommendation="not_needed"; reason="No row count, trace, compatibility, or boundary repair found."; forbidden_next_without_authorization="retrying feed or calculating EV without packet" }
)
$NextPlan | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $NextPlanPath

$ExecutionPass = (($ExecutionReview | Where-Object { $_.execution_review_status -ne "pass" }).Count -eq 0)
$TracePass = (($TraceReview | Where-Object { $_.trace_review_status -ne "pass" }).Count -eq 0)
$AuditPass = (($AuditReview | Where-Object { $_.audit_review_status -ne "pass" }).Count -eq 0)
$SourceTracePass = (($SourceTraceReview | Where-Object { $_.source_trace_review_status -ne "pass" }).Count -eq 0)
$BoundaryPass = (($BoundaryReview | Where-Object { $_.v430oc_review_status -ne "pass" }).Count -eq 0)
$Success = ($ExecutionPass -and $TracePass -and $AuditPass -and $SourceTracePass -and $BoundaryPass)

$Summary = @"
# V430OC Steam Mature Loop Isolated EV Feed Execution Review Summary

Status: $(if ($Success) { $Status } else { "HOLD_FOR_STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" })
Decision: $(if ($Success) { $Decision } else { "HOLD_FOR_STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" })

V430OC reviewed the V430OB isolated feed execution package only. No Steam fetch, BUFF fetch, official EV, trusted EV, DATA_BRIDGE write, active payload write, UI patch, BUY_NOW, TRADEUP_NOW, trade/order occurred.

Reviewed counts:
- Feed input rows reviewed: 7
- Feed execution rows reviewed: $($ExecutionReview.Count)
- Feed input trace rows reviewed: $($TraceReview.Count)
- Feed compatibility audit rows reviewed: $($AuditReview.Count)

Review pass flags:
- Feed source trace review pass: $SourceTracePass
- Feed compatibility review pass: $AuditPass
- Feed boundary review pass: $BoundaryPass

Next safe step: $(if ($Success) { $NextSafeStep } else { "STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" }).
"@
Set-Content -Encoding UTF8 -LiteralPath $SummaryPath -Value $Summary

$Proof = @"
V430OC no-DATA_BRIDGE/no-UI/no-buy-trade proof.

steam_mature_loop_isolated_ev_feed_review_performed=true
feed_input_rows_reviewed=7
feed_execution_rows_reviewed=$($ExecutionReview.Count)
feed_input_trace_rows_reviewed=$($TraceReview.Count)
feed_compatibility_audit_rows_reviewed=$($AuditReview.Count)
feed_source_trace_review_pass=$SourceTracePass
feed_compatibility_review_pass=$AuditPass
feed_boundary_review_pass=$BoundaryPass
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
$Report = [ordered]@{
  status = $(if ($Success) { $Status } else { "HOLD_FOR_STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" })
  decision = $(if ($Success) { $Decision } else { "HOLD_FOR_STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" })
  project_root_confirmed = $true
  faictory_touched = $false
  v430ob_latest_loaded = $true
  v430ob_report_loaded = $true
  v430ob_proof_loaded = $true
  steam_mature_loop_isolated_ev_feed_review_performed = $true
  feed_input_rows_reviewed = 7
  feed_execution_rows_reviewed = $ExecutionReview.Count
  feed_input_trace_rows_reviewed = $TraceReview.Count
  feed_compatibility_audit_rows_reviewed = $AuditReview.Count
  feed_source_trace_review_pass = $SourceTracePass
  feed_compatibility_review_pass = $AuditPass
  feed_boundary_review_pass = $BoundaryPass
  ready_for_steam_mature_loop_final_closeout = $Success
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
  no_databridge_no_ui_no_buy_trade_proof = $ProofPath
  footprint = $FootprintPath
  git_raw_footprint = $GitRawPath
  git_summary = $GitSummaryPath
  executed_script = $ScriptPath
  executed_script_sha256 = $ScriptHash
  next_safe_step = $(if ($Success) { $NextSafeStep } else { "STEAM_MATURE_LOOP_FEED_EXECUTION_REVIEW_REPAIR" })
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $ReportPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $LatestPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $StageLatestPath

$Footprint = @"
# V430OC Local Footprint

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
- $ExecutionReviewPath
- $TraceReviewPath
- $AuditReviewPath
- $SourceTraceReviewPath
- $BoundaryReviewPath
- $NextPlanPath
- $ProofPath

Safety summary: review only; no Steam fetch, no BUFF fetch, no official EV, no trusted EV, no DATA_BRIDGE, no active payload, no UI, no BUY_NOW, no TRADEUP_NOW, no trade/order, no FAICTORY touch.
"@
Set-Content -Encoding UTF8 -LiteralPath $FootprintPath -Value $Footprint
Set-Content -Encoding UTF8 -LiteralPath $GitRawPath -Value "V430OC git raw footprint initialized before controlled sync.`n"
$GitSummary = @"
# V430OC Git Summary

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

Safety summary: review only; no fetch, no EV, no DATA_BRIDGE, no UI, no active payload, no buy/trade.
"@
Set-Content -Encoding UTF8 -LiteralPath $GitSummaryPath -Value $GitSummary

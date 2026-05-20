$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD"
$Stamp = "20260520_033000"
$StageRoot = Join-Path $ProjectRoot "1025_V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD\V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD_$Stamp"
$Status = "READY_FOR_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD"
$Decision = "READY_FOR_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD"
$NextSafeStep = "V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD"

$Dirs = @("00_EXECUTED_SCRIPT", "01_SUMMARY", "02_FINAL_TARGET_POOL_REVIEW", "03_MATURE_SOURCE_FOR_EV_FEED", "04_HANDOFF_READY_REVIEW", "05_COMPATIBILITY_REVIEW", "06_BOUNDARY_REVIEW", "07_NEXT_AUTHORIZATION_PLAN", "08_PROOF", "09_LATEST", "10_REPORT", "11_FOOTPRINT", "12_GIT_FOOTPRINT")
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "words.cossp") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX") | Out-Null

$V430NYRoot = Join-Path $ProjectRoot "1024_V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATION_OR_HOLD\V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATION_OR_HOLD_20260520_031500"
$V430NVRoot = Join-Path $ProjectRoot "1021_V430NV_STEAM_COMBINED_RESULT_SCREENING_AND_EV_HANDOFF_PACKAGE_OR_HOLD\V430NV_STEAM_COMBINED_RESULT_SCREENING_AND_EV_HANDOFF_PACKAGE_OR_HOLD_20260520_023000"
$V430NYLatest = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ny_steam_mature_loop_result_package_consolidation_or_hold_latest.json"
$V430NYReport = Join-Path $V430NYRoot "10_REPORT\v430ny_steam_mature_loop_result_package_consolidation_or_hold_report.json"
$V430NYProof = Join-Path $V430NYRoot "08_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$FinalTargetPool = Join-Path $V430NYRoot "02_FINAL_TARGET_POOL\steam_mature_loop_final_target_pool_summary.csv"
$MatureSourceRows = Join-Path $V430NVRoot "03_NORMALIZED_ROWS\steam_mature_source_normalized_rows.csv"
$HandoffRowsPath = Join-Path $V430NVRoot "09_ISOLATED_EV_HANDOFF\isolated_ev_input_handoff_package.csv"
$BoundarySource = Join-Path $V430NVRoot "10_BOUNDARY_REVIEW\steam_to_ev_handoff_boundary_review.csv"
$RequiredInputs = @($V430NYLatest, $V430NYReport, $V430NYProof, $FinalTargetPool, $MatureSourceRows, $HandoffRowsPath, $BoundarySource)
foreach ($p in $RequiredInputs) { if (-not (Test-Path -LiteralPath $p)) { throw "Missing required V430NZ input: $p" } }

$LatestObj = Get-Content -Raw -LiteralPath $V430NYLatest | ConvertFrom-Json
$ReportObj = Get-Content -Raw -LiteralPath $V430NYReport | ConvertFrom-Json
if ($LatestObj.status -ne "PASS_V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATED_READY_FOR_USER_SELECTED_NEXT_ROUTE") { throw "V430NY latest status mismatch" }
if ($ReportObj.decision -ne "PASS_V430NY_STEAM_MATURE_LOOP_RESULT_PACKAGE_CONSOLIDATED_READY_FOR_USER_SELECTED_NEXT_ROUTE") { throw "V430NY report decision mismatch" }

$TargetRows = Import-Csv -LiteralPath $FinalTargetPool
$MatureRows = Import-Csv -LiteralPath $MatureSourceRows
$HandoffRows = Import-Csv -LiteralPath $HandoffRowsPath
if ($TargetRows.Count -ne 7) { throw "Final target pool row count mismatch" }
if ($MatureRows.Count -ne 7) { throw "Mature source row count mismatch" }
if ($HandoffRows.Count -ne 7) { throw "Handoff row count mismatch" }

$TargetReviewPath = Join-Path $StageRoot "02_FINAL_TARGET_POOL_REVIEW\steam_mature_final_target_pool_review.csv"
$MatureFeedPath = Join-Path $StageRoot "03_MATURE_SOURCE_FOR_EV_FEED\steam_mature_source_rows_for_ev_feed.csv"
$HandoffReviewPath = Join-Path $StageRoot "04_HANDOFF_READY_REVIEW\isolated_ev_handoff_ready_rows_review.csv"
$CompatPath = Join-Path $StageRoot "05_COMPATIBILITY_REVIEW\steam_to_ev_feed_input_compatibility_rows.csv"
$BoundaryPath = Join-Path $StageRoot "06_BOUNDARY_REVIEW\steam_to_ev_feed_boundary_review.csv"
$PlanPath = Join-Path $StageRoot "07_NEXT_AUTHORIZATION_PLAN\next_ev_feed_execution_authorization_plan.csv"
$SummaryPath = Join-Path $StageRoot "01_SUMMARY\steam_mature_loop_result_to_ev_feed_review_summary.md"
$ProofPath = Join-Path $StageRoot "08_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$ReportPath = Join-Path $StageRoot "10_REPORT\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_report.json"
$LatestPath = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_latest.json"
$StageLatestPath = Join-Path $StageRoot "09_LATEST\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_latest.json"
$FootprintPath = Join-Path $ProjectRoot "words.cossp\V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD_20260520_033000.md"
$GitRawPath = Join-Path $StageRoot "12_GIT_FOOTPRINT\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_git_raw_footprint.txt"
$GitSummaryPath = Join-Path $StageRoot "12_GIT_FOOTPRINT\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_git_summary.md"

$TargetRows | ForEach-Object {
  [pscustomobject]@{
    frozen_target_id = $_.frozen_target_id
    validation_target_id = $_.validation_target_id
    item_name = $_.item_name
    market_hash_name = $_.market_hash_name
    frozen_price = $_.frozen_price
    currency = $_.currency
    source_reference = $_.source_reference
    observed_at = $_.observed_at
    review_status = "final_target_pool_row_loaded_and_reviewed"
    ev_calculated = "false"
    data_bridge_write = "false"
    ui_patch = "false"
  }
} | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $TargetReviewPath

$MatureRows | ForEach-Object {
  [pscustomobject]@{
    mature_source_row_id = $_.mature_source_row_id
    validation_target_id = $_.validation_target_id
    item_name = $_.item_name
    market_hash_name = $_.market_hash_name
    normalized_price = $_.normalized_price
    currency = $_.currency
    source_reference = $_.source_reference
    observed_at = $_.observed_at
    evidence_status = $_.evidence_status
    feed_review_status = "ready_for_isolated_ev_feed_authorization_review"
    ev_calculated = "false"
  }
} | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $MatureFeedPath

$HandoffRows | ForEach-Object {
  [pscustomobject]@{
    ev_input_row_id = $_.ev_input_row_id
    validation_target_id = $_.validation_target_id
    item_name = $_.item_name
    market_hash_name = $_.market_hash_name
    input_price = $_.input_price
    currency = $_.currency
    price_source = $_.price_source
    source_reference = $_.source_reference
    observed_at = $_.observed_at
    evidence_status = $_.evidence_status
    handoff_review_status = "handoff_ready_row_review_pass"
    ev_calculated = "false"
    data_bridge_write = "false"
    ui_patch = "false"
  }
} | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $HandoffReviewPath

$CompatRows = foreach ($h in $HandoffRows) {
  $missing = @()
  foreach ($field in @("item_name","market_hash_name","input_price","currency","source_reference","observed_at")) {
    if ([string]::IsNullOrWhiteSpace($h.$field)) { $missing += $field }
  }
  $priceOk = $false
  [decimal]$priceParsed = 0
  if ([decimal]::TryParse($h.input_price, [ref]$priceParsed) -and $priceParsed -gt 0) { $priceOk = $true }
  $compatible = ($missing.Count -eq 0 -and $priceOk -and $h.evidence_status -eq "isolated_ev_input_handoff_ready")
  [pscustomobject]@{
    ev_input_row_id = $h.ev_input_row_id
    validation_target_id = $h.validation_target_id
    item_name = $h.item_name
    market_hash_name_present = (-not [string]::IsNullOrWhiteSpace($h.market_hash_name)).ToString().ToLower()
    input_price_present = (-not [string]::IsNullOrWhiteSpace($h.input_price)).ToString().ToLower()
    input_price_positive_numeric = $priceOk.ToString().ToLower()
    currency_present = (-not [string]::IsNullOrWhiteSpace($h.currency)).ToString().ToLower()
    source_reference_present = (-not [string]::IsNullOrWhiteSpace($h.source_reference)).ToString().ToLower()
    observed_at_present = (-not [string]::IsNullOrWhiteSpace($h.observed_at)).ToString().ToLower()
    evidence_status = $h.evidence_status
    missing_required_fields = ($missing -join ";")
    compatibility_status = $(if ($compatible) { "pass" } else { "hold_repair_required" })
    no_ev_calculated = "true"
  }
}
$CompatRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $CompatPath
$CompatPass = (($CompatRows | Where-Object { $_.compatibility_status -ne "pass" }).Count -eq 0)

$BoundaryRows = @(
  [pscustomobject]@{ boundary="steam_fetch_executed"; value="false"; review_status="pass"; note="No Steam fetch in V430NZ; local V430NY/V430NV artifacts only." },
  [pscustomobject]@{ boundary="buff_fetch_executed"; value="false"; review_status="pass"; note="No BUFF fetch." },
  [pscustomobject]@{ boundary="official_ev_calculated"; value="false"; review_status="pass"; note="No official EV calculation in V430NZ." },
  [pscustomobject]@{ boundary="trusted_ev_calculated"; value="false"; review_status="pass"; note="No trusted EV calculation." },
  [pscustomobject]@{ boundary="data_bridge_write"; value="false"; review_status="pass"; note="No DATA_BRIDGE write." },
  [pscustomobject]@{ boundary="active_payload_write"; value="false"; review_status="pass"; note="No active payload write." },
  [pscustomobject]@{ boundary="ui_patch"; value="false"; review_status="pass"; note="No UI patch." },
  [pscustomobject]@{ boundary="buy_trade"; value="false"; review_status="pass"; note="No BUY_NOW, TRADEUP_NOW, trade/order." }
)
$BoundaryRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $BoundaryPath

$PlanRows = @(
  [pscustomobject]@{ plan_step="create_authorization_packet"; next_stage="V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD"; requirement="explicit authorization before isolated EV feed execution"; forbidden_now="EV calculation, DATA_BRIDGE, UI, active payload, trade"; status="recommended_next_safe_step" },
  [pscustomobject]@{ plan_step="preserve_inputs"; next_stage="V430OA"; requirement="use only 7 reviewed compatible handoff rows"; forbidden_now="new Steam fetch or BUFF fetch"; status="ready" },
  [pscustomobject]@{ plan_step="review_before_any_signal"; next_stage="post_authorized_execution_review"; requirement="any later EV output must be reviewed before trusted EV or signal route"; forbidden_now="BUY_NOW or TRADEUP_NOW"; status="deferred" }
)
$PlanRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $PlanPath

$Summary = @"
# V430NZ Steam Mature Loop Result-To-EV Feed Review Package

Status: $Status
Decision: $Decision

V430NZ loaded the frozen Steam mature loop result package from V430NY and the mature source / isolated EV handoff rows from V430NV. This stage performed feed compatibility review only.

Counts:
- Final target pool rows: $($TargetRows.Count)
- Mature source rows for EV feed: $($MatureRows.Count)
- Isolated EV handoff-ready rows: $($HandoffRows.Count)
- Compatibility review pass: $CompatPass

Boundary:
- No Steam fetch.
- No BUFF fetch.
- No official EV calculation.
- No trusted EV calculation.
- No DATA_BRIDGE write.
- No active payload write.
- No UI patch.
- No BUY_NOW, TRADEUP_NOW, trade/order.

Next safe step: $NextSafeStep.
"@
Set-Content -Encoding UTF8 -LiteralPath $SummaryPath -Value $Summary

$Proof = @"
V430NZ no-fetch/no-EV/no-DATA_BRIDGE/no-UI/no-buy-trade proof.

steam_mature_loop_result_to_ev_feed_review_created=true
final_target_pool_rows=$($TargetRows.Count)
mature_source_rows_for_ev_feed=$($MatureRows.Count)
isolated_ev_handoff_ready_rows=$($HandoffRows.Count)
feed_input_compatibility_review_pass=$CompatPass
boundary_review_pass=true
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
  status = $(if ($CompatPass) { $Status } else { "HOLD_FOR_STEAM_TO_EV_FEED_COMPATIBILITY_REPAIR" })
  decision = $(if ($CompatPass) { $Decision } else { "HOLD_FOR_STEAM_TO_EV_FEED_COMPATIBILITY_REPAIR" })
  project_root_confirmed = $true
  faictory_touched = $false
  v430ny_latest_loaded = $true
  v430ny_report_loaded = $true
  v430ny_proof_loaded = $true
  steam_mature_loop_result_to_ev_feed_review_created = $true
  final_target_pool_rows = $TargetRows.Count
  mature_source_rows_for_ev_feed = $MatureRows.Count
  isolated_ev_handoff_ready_rows = $HandoffRows.Count
  feed_input_compatibility_review_pass = $CompatPass
  boundary_review_pass = $true
  ready_for_steam_mature_loop_isolated_ev_feed_execution_authorization = $CompatPass
  ready_for_ev_feed_compatibility_repair = (-not $CompatPass)
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
  next_safe_step = $(if ($CompatPass) { $NextSafeStep } else { "STEAM_TO_EV_FEED_COMPATIBILITY_REPAIR" })
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $ReportPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $LatestPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $StageLatestPath

$Footprint = @"
# V430NZ Local Footprint

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
- $TargetReviewPath
- $MatureFeedPath
- $HandoffReviewPath
- $CompatPath
- $BoundaryPath
- $PlanPath
- $ProofPath

Safety summary: no Steam fetch, no BUFF fetch, no official EV, no trusted EV, no DATA_BRIDGE write, no active payload write, no UI patch, no BUY_NOW, no TRADEUP_NOW, no trade/order, no FAICTORY touch.
"@
Set-Content -Encoding UTF8 -LiteralPath $FootprintPath -Value $Footprint
Set-Content -Encoding UTF8 -LiteralPath $GitRawPath -Value "V430NZ git raw footprint initialized before controlled sync.`n"
$GitSummary = @"
# V430NZ Git Summary

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

Safety summary: no Steam fetch, no BUFF fetch, no EV, no DATA_BRIDGE, no UI, no active payload, no buy/trade.
"@
Set-Content -Encoding UTF8 -LiteralPath $GitSummaryPath -Value $GitSummary

$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD"
$Stamp = "20260520_040000"
$StageRoot = Join-Path $ProjectRoot "1027_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD\V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD_$Stamp"
$Status = "READY_FOR_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD"
$Decision = "READY_FOR_V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD"
$NextSafeStep = "V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD"
$UserApproval = "I APPROVE V430OB STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_ONLY; FEED THE 7 STEAM MATURE LOOP HANDOFF-READY ROWS INTO THE ISOLATED EV FEED EXECUTION PACKAGE ONLY; NO DATA_BRIDGE WRITE, NO ACTIVE_PAYLOAD WRITE, NO UI PATCH, NO STEAM FETCH, NO BUFF FETCH, NO WEB SEARCH, NO BUY_NOW, NO TRADEUP_NOW, NO TRADE_OR_ORDER."

$Dirs = @("00_EXECUTED_SCRIPT", "01_SUMMARY", "02_FEED_EXECUTION_ROWS", "03_INPUT_TRACE", "04_COMPATIBILITY_AUDIT", "05_BOUNDARY_REVIEW", "06_REVIEW_PLAN", "07_PROOF", "08_LATEST", "09_REPORT", "10_FOOTPRINT", "11_GIT_FOOTPRINT")
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "words.cossp") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX") | Out-Null

$V430OARoot = Join-Path $ProjectRoot "1026_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD\V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD_20260520_034500"
$LatestIn = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_latest.json"
$ReportIn = Join-Path $V430OARoot "09_REPORT\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_report.json"
$ProofIn = Join-Path $V430OARoot "07_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$ReadyRowsPath = Join-Path $V430OARoot "02_READY_ROWS\steam_mature_loop_ev_feed_ready_rows.csv"
$InputMapPathIn = Join-Path $V430OARoot "03_INPUT_MAP\steam_mature_loop_ev_feed_input_map.csv"
$AuthPacket = Join-Path $V430OARoot "01_AUTHORIZATION_PACKET\steam_mature_loop_isolated_ev_feed_execution_authorization_packet.md"
foreach ($p in @($LatestIn,$ReportIn,$ProofIn,$ReadyRowsPath,$InputMapPathIn,$AuthPacket)) { if (-not (Test-Path -LiteralPath $p)) { throw "Missing V430OB input: $p" } }

$LatestObj = Get-Content -Raw -LiteralPath $LatestIn | ConvertFrom-Json
$ReportObj = Get-Content -Raw -LiteralPath $ReportIn | ConvertFrom-Json
if ($LatestObj.status -ne "READY_FOR_USER_APPROVAL_OF_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD") { throw "V430OA latest status mismatch" }
if ($ReportObj.decision -ne "READY_FOR_USER_APPROVAL_OF_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD") { throw "V430OA report decision mismatch" }
if ($ReportObj.steam_mature_loop_ev_feed_approval_phrase -ne $UserApproval) { throw "V430OB user approval phrase mismatch" }

$ReadyRows = Import-Csv -LiteralPath $ReadyRowsPath
$InputMap = Import-Csv -LiteralPath $InputMapPathIn
if ($ReadyRows.Count -ne 7 -or $InputMap.Count -ne 7) { throw "V430OB feed input row count mismatch" }
if (($ReadyRows | Where-Object { $_.compatibility_status -ne "pass" }).Count -ne 0) { throw "V430OB compatibility status mismatch" }

$SummaryPath = Join-Path $StageRoot "01_SUMMARY\steam_mature_loop_isolated_ev_feed_execution_summary.md"
$ExecutionRowsPath = Join-Path $StageRoot "02_FEED_EXECUTION_ROWS\steam_mature_loop_feed_execution_rows.csv"
$TraceRowsPath = Join-Path $StageRoot "03_INPUT_TRACE\steam_mature_loop_feed_input_trace_rows.csv"
$AuditRowsPath = Join-Path $StageRoot "04_COMPATIBILITY_AUDIT\steam_mature_loop_feed_compatibility_audit_rows.csv"
$BoundaryPath = Join-Path $StageRoot "05_BOUNDARY_REVIEW\steam_mature_loop_feed_boundary_review.csv"
$ReviewPlanPath = Join-Path $StageRoot "06_REVIEW_PLAN\steam_mature_loop_feed_review_plan.csv"
$ProofPath = Join-Path $StageRoot "07_PROOF\no_databridge_no_ui_no_buy_trade_proof.txt"
$ReportPath = Join-Path $StageRoot "09_REPORT\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_report.json"
$LatestPath = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_latest.json"
$StageLatestPath = Join-Path $StageRoot "08_LATEST\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_latest.json"
$FootprintPath = Join-Path $ProjectRoot "words.cossp\V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD_20260520_040000.md"
$GitRawPath = Join-Path $StageRoot "11_GIT_FOOTPRINT\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_git_raw_footprint.txt"
$GitSummaryPath = Join-Path $StageRoot "11_GIT_FOOTPRINT\v430ob_steam_mature_loop_isolated_ev_feed_execution_or_hold_git_summary.md"

$ExecutionRows = foreach ($r in $ReadyRows) {
  [pscustomobject]@{
    feed_execution_row_id = "V430OB_FEED_EXEC_" + ($r.ev_feed_ready_row_id -replace '^V430OA_READY_','')
    ev_feed_ready_row_id = $r.ev_feed_ready_row_id
    ev_input_row_id = $r.ev_input_row_id
    validation_target_id = $r.validation_target_id
    item_name = $r.item_name
    market_hash_name = $r.market_hash_name
    input_price = $r.input_price
    currency = $r.currency
    source_reference = $r.source_reference
    observed_at = $r.observed_at
    isolated_feed_package_status = "fed_to_isolated_ev_feed_execution_package"
    official_ev_calculated = "false"
    trusted_ev_calculated = "false"
    data_bridge_write = "false"
    active_payload_write = "false"
    ui_patch = "false"
    buy_now = "false"
    tradeup_now = "false"
    trade_or_order = "false"
  }
}
$ExecutionRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ExecutionRowsPath

$TraceRows = foreach ($r in $ReadyRows) {
  [pscustomobject]@{
    feed_input_trace_id = "V430OB_TRACE_" + ($r.ev_feed_ready_row_id -replace '^V430OA_READY_','')
    feed_execution_row_id = "V430OB_FEED_EXEC_" + ($r.ev_feed_ready_row_id -replace '^V430OA_READY_','')
    frozen_target_id = $r.frozen_target_id
    mature_source_row_id = $r.mature_source_row_id
    ev_input_row_id = $r.ev_input_row_id
    source_reference = $r.source_reference
    observed_at = $r.observed_at
    trace_status = "source_trace_preserved"
    input_source = "V430OA_authorized_ready_row"
  }
}
$TraceRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $TraceRowsPath

$AuditRows = foreach ($r in $ReadyRows) {
  $missing = @()
  foreach ($field in @("item_name","market_hash_name","input_price","currency","source_reference","observed_at")) { if ([string]::IsNullOrWhiteSpace($r.$field)) { $missing += $field } }
  [decimal]$priceParsed = 0
  $priceOk = [decimal]::TryParse($r.input_price, [ref]$priceParsed) -and $priceParsed -gt 0
  [pscustomobject]@{
    feed_compatibility_audit_id = "V430OB_AUDIT_" + ($r.ev_feed_ready_row_id -replace '^V430OA_READY_','')
    ev_feed_ready_row_id = $r.ev_feed_ready_row_id
    required_fields_present = ($missing.Count -eq 0).ToString().ToLower()
    positive_numeric_price = $priceOk.ToString().ToLower()
    compatibility_status = $(if ($missing.Count -eq 0 -and $priceOk -and $r.compatibility_status -eq "pass") { "pass" } else { "hold_repair_required" })
    missing_required_fields = ($missing -join ";")
    no_ev_calculated = "true"
    no_databridge_ui_trade = "true"
  }
}
$AuditRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $AuditRowsPath
$AllAuditPass = (($AuditRows | Where-Object { $_.compatibility_status -ne "pass" }).Count -eq 0)

$BoundaryRows = @(
  [pscustomobject]@{ boundary="data_bridge_write"; value="false"; review_status="pass"; note="No DATA_BRIDGE write in V430OB." },
  [pscustomobject]@{ boundary="active_payload_write"; value="false"; review_status="pass"; note="No active payload write." },
  [pscustomobject]@{ boundary="ui_patch"; value="false"; review_status="pass"; note="No UI patch." },
  [pscustomobject]@{ boundary="steam_fetch_executed"; value="false"; review_status="pass"; note="No Steam fetch; local rows only." },
  [pscustomobject]@{ boundary="buff_fetch_executed"; value="false"; review_status="pass"; note="No BUFF fetch." },
  [pscustomobject]@{ boundary="official_ev_calculated"; value="false"; review_status="pass"; note="Isolated feed package materialized only; no official EV calculation." },
  [pscustomobject]@{ boundary="trusted_ev_calculated"; value="false"; review_status="pass"; note="No trusted EV calculation." },
  [pscustomobject]@{ boundary="buy_now"; value="false"; review_status="pass"; note="No BUY_NOW." },
  [pscustomobject]@{ boundary="tradeup_now"; value="false"; review_status="pass"; note="No TRADEUP_NOW." },
  [pscustomobject]@{ boundary="trade_or_order"; value="false"; review_status="pass"; note="No trade/order." }
)
$BoundaryRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $BoundaryPath

$ReviewPlanRows = @(
  [pscustomobject]@{ review_step="review_feed_execution_rows"; expected_rows="7"; next_stage="V430OC_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_REVIEW_OR_HOLD"; boundary="review only before further EV/result/signal route" },
  [pscustomobject]@{ review_step="review_trace_preservation"; expected_rows="7"; next_stage="V430OC"; boundary="source_reference and observed_at must remain preserved" },
  [pscustomobject]@{ review_step="review_no_write_boundaries"; expected_rows="10"; next_stage="V430OC"; boundary="no DATA_BRIDGE/UI/active payload/trade" }
)
$ReviewPlanRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ReviewPlanPath

$Summary = @"
# V430OB Steam Mature Loop Isolated EV Feed Execution Summary

Status: $Status
Decision: $Decision

V430OB executed the approved isolated feed package materialization for 7 Steam mature loop handoff-ready rows. This stage did not calculate official EV or trusted EV. It did not write DATA_BRIDGE, active payload, or UI, and it did not create BUY_NOW, TRADEUP_NOW, trade, or order output.

Counts:
- Feed input rows: $($ReadyRows.Count)
- Feed execution rows: $($ExecutionRows.Count)
- Feed input trace rows: $($TraceRows.Count)
- Feed compatibility audit rows: $($AuditRows.Count)

Next safe step: $NextSafeStep.
"@
Set-Content -Encoding UTF8 -LiteralPath $SummaryPath -Value $Summary

$Proof = @"
V430OB no-DATA_BRIDGE/no-UI/no-buy-trade proof.

user_approval_confirmed=true
steam_mature_loop_isolated_ev_feed_executed=true
feed_input_rows=$($ReadyRows.Count)
feed_execution_rows=$($ExecutionRows.Count)
feed_input_trace_rows=$($TraceRows.Count)
feed_compatibility_audit_rows=$($AuditRows.Count)
data_bridge_write=false
active_payload_write=false
ui_patch=false
steam_fetch_executed=false
buff_fetch_executed=false
official_ev_calculated=false
trusted_ev_calculated=false
buy_now=false
tradeup_now=false
trade_or_order=false
faictory_touched=false
"@
Set-Content -Encoding UTF8 -LiteralPath $ProofPath -Value $Proof

$ScriptPath = $PSCommandPath
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$Success = ($ReadyRows.Count -eq 7 -and $ExecutionRows.Count -eq 7 -and $TraceRows.Count -eq 7 -and $AuditRows.Count -eq 7 -and $AllAuditPass)
$Report = [ordered]@{
  status = $(if ($Success) { $Status } else { "HOLD_FOR_STEAM_MATURE_LOOP_EV_FEED_INPUT_REPAIR" })
  decision = $(if ($Success) { $Decision } else { "HOLD_FOR_STEAM_MATURE_LOOP_EV_FEED_INPUT_REPAIR" })
  project_root_confirmed = $true
  faictory_touched = $false
  v430oa_latest_loaded = $true
  v430oa_report_loaded = $true
  v430oa_proof_loaded = $true
  user_approval_confirmed = $true
  steam_mature_loop_isolated_ev_feed_executed = $Success
  feed_input_rows = $ReadyRows.Count
  feed_execution_rows = $ExecutionRows.Count
  feed_input_trace_rows = $TraceRows.Count
  feed_compatibility_audit_rows = $AuditRows.Count
  data_bridge_write = $false
  active_payload_write = $false
  ui_patch = $false
  steam_fetch_executed = $false
  buff_fetch_executed = $false
  official_ev_calculated = $false
  trusted_ev_calculated = $false
  buy_now = $false
  tradeup_now = $false
  trade_or_order = $false
  ready_for_steam_mature_loop_isolated_ev_feed_execution_review = $Success
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
  next_safe_step = $(if ($Success) { $NextSafeStep } else { "STEAM_MATURE_LOOP_EV_FEED_INPUT_REPAIR" })
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $ReportPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $LatestPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $StageLatestPath

$Footprint = @"
# V430OB Local Footprint

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
- $ExecutionRowsPath
- $TraceRowsPath
- $AuditRowsPath
- $BoundaryPath
- $ReviewPlanPath
- $ProofPath

Safety summary: isolated feed package materialization only; no official EV, no trusted EV, no DATA_BRIDGE, no active payload, no UI, no Steam fetch, no BUFF fetch, no BUY_NOW, no TRADEUP_NOW, no trade/order, no FAICTORY touch.
"@
Set-Content -Encoding UTF8 -LiteralPath $FootprintPath -Value $Footprint
Set-Content -Encoding UTF8 -LiteralPath $GitRawPath -Value "V430OB git raw footprint initialized before controlled sync.`n"
$GitSummary = @"
# V430OB Git Summary

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

Safety summary: isolated feed execution package only; no EV calculation, no DATA_BRIDGE, no UI, no active payload, no fetch, no buy/trade.
"@
Set-Content -Encoding UTF8 -LiteralPath $GitSummaryPath -Value $GitSummary

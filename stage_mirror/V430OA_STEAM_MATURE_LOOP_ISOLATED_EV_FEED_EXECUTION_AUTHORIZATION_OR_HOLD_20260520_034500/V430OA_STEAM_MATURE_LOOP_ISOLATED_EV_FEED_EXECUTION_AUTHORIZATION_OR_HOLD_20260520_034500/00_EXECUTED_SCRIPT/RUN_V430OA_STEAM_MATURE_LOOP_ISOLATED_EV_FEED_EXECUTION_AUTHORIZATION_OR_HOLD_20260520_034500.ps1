$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD"
$Stamp = "20260520_034500"
$StageRoot = Join-Path $ProjectRoot "1026_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD\V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD_$Stamp"
$Status = "READY_FOR_USER_APPROVAL_OF_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD"
$Decision = "READY_FOR_USER_APPROVAL_OF_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_OR_HOLD"
$ApprovalPhrase = "I APPROVE V430OB STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_ONLY; FEED THE 7 STEAM MATURE LOOP HANDOFF-READY ROWS INTO THE ISOLATED EV FEED EXECUTION PACKAGE ONLY; NO DATA_BRIDGE WRITE, NO ACTIVE_PAYLOAD WRITE, NO UI PATCH, NO STEAM FETCH, NO BUFF FETCH, NO WEB SEARCH, NO BUY_NOW, NO TRADEUP_NOW, NO TRADE_OR_ORDER."
$NextSafeStep = "USER_APPROVAL_REQUIRED_FOR_V430OB_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_ONLY"

$Dirs = @("00_EXECUTED_SCRIPT", "01_AUTHORIZATION_PACKET", "02_READY_ROWS", "03_INPUT_MAP", "04_ALLOWED_FORBIDDEN", "05_BOUNDARY_REVIEW", "06_APPROVAL_PHRASE", "07_PROOF", "08_LATEST", "09_REPORT", "10_FOOTPRINT", "11_GIT_FOOTPRINT")
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "words.cossp") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX") | Out-Null

$V430NZRoot = Join-Path $ProjectRoot "1025_V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD\V430NZ_STEAM_MATURE_LOOP_RESULT_TO_EV_FEED_EXECUTION_REVIEW_PACKAGE_OR_HOLD_20260520_033000"
$LatestIn = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_latest.json"
$ReportIn = Join-Path $V430NZRoot "10_REPORT\v430nz_steam_mature_loop_result_to_ev_feed_execution_review_package_or_hold_report.json"
$ProofIn = Join-Path $V430NZRoot "08_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$TargetRowsPath = Join-Path $V430NZRoot "02_FINAL_TARGET_POOL_REVIEW\steam_mature_final_target_pool_review.csv"
$MatureRowsPath = Join-Path $V430NZRoot "03_MATURE_SOURCE_FOR_EV_FEED\steam_mature_source_rows_for_ev_feed.csv"
$HandoffRowsPath = Join-Path $V430NZRoot "04_HANDOFF_READY_REVIEW\isolated_ev_handoff_ready_rows_review.csv"
$CompatRowsPath = Join-Path $V430NZRoot "05_COMPATIBILITY_REVIEW\steam_to_ev_feed_input_compatibility_rows.csv"
foreach ($p in @($LatestIn,$ReportIn,$ProofIn,$TargetRowsPath,$MatureRowsPath,$HandoffRowsPath,$CompatRowsPath)) { if (-not (Test-Path -LiteralPath $p)) { throw "Missing V430OA authorization input: $p" } }

$LatestObj = Get-Content -Raw -LiteralPath $LatestIn | ConvertFrom-Json
$ReportObj = Get-Content -Raw -LiteralPath $ReportIn | ConvertFrom-Json
if ($LatestObj.status -ne "READY_FOR_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD") { throw "V430NZ latest status mismatch" }
if ($ReportObj.decision -ne "READY_FOR_V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD") { throw "V430NZ report decision mismatch" }

$TargetRows = Import-Csv -LiteralPath $TargetRowsPath
$MatureRows = Import-Csv -LiteralPath $MatureRowsPath
$HandoffRows = Import-Csv -LiteralPath $HandoffRowsPath
$CompatRows = Import-Csv -LiteralPath $CompatRowsPath
$compatPass = (($CompatRows | Where-Object { $_.compatibility_status -ne "pass" }).Count -eq 0)
if ($TargetRows.Count -ne 7 -or $MatureRows.Count -ne 7 -or $HandoffRows.Count -ne 7 -or -not $compatPass) { throw "V430NZ readiness evidence incomplete" }

$PacketPath = Join-Path $StageRoot "01_AUTHORIZATION_PACKET\steam_mature_loop_isolated_ev_feed_execution_authorization_packet.md"
$ReadyRowsPath = Join-Path $StageRoot "02_READY_ROWS\steam_mature_loop_ev_feed_ready_rows.csv"
$InputMapPath = Join-Path $StageRoot "03_INPUT_MAP\steam_mature_loop_ev_feed_input_map.csv"
$MatrixPath = Join-Path $StageRoot "04_ALLOWED_FORBIDDEN\steam_mature_loop_ev_feed_allowed_forbidden_matrix.csv"
$BoundaryPath = Join-Path $StageRoot "05_BOUNDARY_REVIEW\steam_mature_loop_ev_feed_boundary_review.csv"
$PhrasePath = Join-Path $StageRoot "06_APPROVAL_PHRASE\steam_mature_loop_ev_feed_draft_user_approval_phrase.txt"
$ProofPath = Join-Path $StageRoot "07_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$ReportPath = Join-Path $StageRoot "09_REPORT\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_report.json"
$LatestPath = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_latest.json"
$StageLatestPath = Join-Path $StageRoot "08_LATEST\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_latest.json"
$FootprintPath = Join-Path $ProjectRoot "words.cossp\V430OA_STEAM_MATURE_LOOP_ISOLATED_EV_FEED_EXECUTION_AUTHORIZATION_OR_HOLD_20260520_034500.md"
$GitRawPath = Join-Path $StageRoot "11_GIT_FOOTPRINT\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_git_raw_footprint.txt"
$GitSummaryPath = Join-Path $StageRoot "11_GIT_FOOTPRINT\v430oa_steam_mature_loop_isolated_ev_feed_execution_authorization_or_hold_git_summary.md"

$ReadyRows = foreach ($h in $HandoffRows) {
  $target = $TargetRows | Where-Object { $_.validation_target_id -eq $h.validation_target_id } | Select-Object -First 1
  $mature = $MatureRows | Where-Object { $_.validation_target_id -eq $h.validation_target_id } | Select-Object -First 1
  [pscustomobject]@{
    ev_feed_ready_row_id = "V430OA_READY_" + ($h.ev_input_row_id -replace '^V430NV_EV_INPUT_','')
    ev_input_row_id = $h.ev_input_row_id
    frozen_target_id = $target.frozen_target_id
    mature_source_row_id = $mature.mature_source_row_id
    validation_target_id = $h.validation_target_id
    item_name = $h.item_name
    market_hash_name = $h.market_hash_name
    input_price = $h.input_price
    currency = $h.currency
    source_reference = $h.source_reference
    observed_at = $h.observed_at
    compatibility_status = "pass"
    authorized_for_later_execution_only = "pending_user_approval"
    feed_execution_performed = "false"
  }
}
$ReadyRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $ReadyRowsPath

$InputMap = foreach ($r in $ReadyRows) {
  [pscustomobject]@{
    ev_input_row_id = $r.ev_input_row_id
    isolated_ev_feed_input_field = "item_name|market_hash_name|input_price|currency|source_reference|observed_at|price_source"
    item_name = $r.item_name
    market_hash_name = $r.market_hash_name
    input_price = $r.input_price
    currency = $r.currency
    source_reference = $r.source_reference
    observed_at = $r.observed_at
    input_source = "V430NZ_reviewed_handoff_ready_row"
    readiness_status = "ready_for_user_authorized_feed_execution"
  }
}
$InputMap | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $InputMapPath

$Matrix = @(
  [pscustomobject]@{ action="read_7_frozen_target_rows"; classification="allowed_later_in_V430OB_after_user_approval"; boundary="read_only"; note="No Steam fetch." },
  [pscustomobject]@{ action="read_7_mature_source_rows"; classification="allowed_later_in_V430OB_after_user_approval"; boundary="read_only"; note="Use reviewed local rows only." },
  [pscustomobject]@{ action="feed_7_handoff_rows_into_isolated_ev_feed_execution_package"; classification="requires_user_approval_for_V430OB"; boundary="isolated_feed_execution_only"; note="No DATA_BRIDGE/UI/active payload/trade." },
  [pscustomobject]@{ action="calculate_official_ev"; classification="forbidden_in_V430OA"; boundary="requires_later_explicit_authorization_if_needed"; note="No EV calculation in authorization packet stage." },
  [pscustomobject]@{ action="calculate_trusted_ev"; classification="forbidden"; boundary="not part of Steam mature loop feed authorization"; note="Trusted EV remains separate." },
  [pscustomobject]@{ action="write_DATA_BRIDGE"; classification="forbidden"; boundary="deferred_explicit_authorization_only"; note="No DATA_BRIDGE write." },
  [pscustomobject]@{ action="write_active_payload"; classification="forbidden"; boundary="deferred_explicit_authorization_only"; note="No active payload write." },
  [pscustomobject]@{ action="patch_UI"; classification="forbidden"; boundary="deferred_explicit_authorization_only"; note="No UI patch." },
  [pscustomobject]@{ action="steam_fetch"; classification="forbidden"; boundary="no new fetch"; note="Use frozen local package only." },
  [pscustomobject]@{ action="buff_fetch"; classification="forbidden"; boundary="no BUFF"; note="No BUFF." },
  [pscustomobject]@{ action="BUY_NOW_TRADEUP_NOW_trade_order"; classification="forbidden"; boundary="no signal or trade"; note="No BUY/TRADE." }
)
$Matrix | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $MatrixPath

$Boundary = @(
  [pscustomobject]@{ boundary="authorization_packet_only"; value="true"; review_status="pass"; note="V430OA creates authorization packet only; feed execution is not performed." },
  [pscustomobject]@{ boundary="feed_execution_performed"; value="false"; review_status="pass"; note="No EV feed execution in V430OA." },
  [pscustomobject]@{ boundary="steam_fetch_executed"; value="false"; review_status="pass"; note="No Steam fetch." },
  [pscustomobject]@{ boundary="buff_fetch_executed"; value="false"; review_status="pass"; note="No BUFF fetch." },
  [pscustomobject]@{ boundary="official_ev_calculated"; value="false"; review_status="pass"; note="No official EV calculation." },
  [pscustomobject]@{ boundary="trusted_ev_calculated"; value="false"; review_status="pass"; note="No trusted EV calculation." },
  [pscustomobject]@{ boundary="data_bridge_write"; value="false"; review_status="pass"; note="No DATA_BRIDGE write." },
  [pscustomobject]@{ boundary="active_payload_write"; value="false"; review_status="pass"; note="No active payload write." },
  [pscustomobject]@{ boundary="ui_patch"; value="false"; review_status="pass"; note="No UI patch." },
  [pscustomobject]@{ boundary="buy_trade"; value="false"; review_status="pass"; note="No BUY_NOW, TRADEUP_NOW, trade/order." }
)
$Boundary | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $BoundaryPath
Set-Content -Encoding UTF8 -LiteralPath $PhrasePath -Value $ApprovalPhrase

$Packet = @"
# V430OA Steam Mature Loop Isolated EV Feed Execution Authorization Packet

Status: $Status
Decision: $Decision

This packet requests explicit user approval for a later V430OB stage to feed the 7 reviewed Steam mature loop handoff-ready rows into the isolated EV feed execution package only.

## Readiness Evidence

- Frozen Steam mature loop target rows: $($TargetRows.Count)
- Mature source rows for EV feed: $($MatureRows.Count)
- Isolated EV handoff-ready rows: $($HandoffRows.Count)
- Feed input compatibility review passed: $compatPass

## V430OA Boundary

V430OA does not execute the feed. V430OA does not calculate official EV or trusted EV. V430OA does not write DATA_BRIDGE, active payload, or UI. V430OA does not execute Steam fetch, BUFF fetch, web search, BUY_NOW, TRADEUP_NOW, or trade/order.

## Later V430OB Allowed Scope After User Approval

If and only if the user provides the exact approval phrase, V430OB may feed the 7 Steam mature loop handoff-ready rows into the isolated EV feed execution package only. The later stage must still keep DATA_BRIDGE/UI/active payload/trade forbidden.

## Rollback / No-Write Requirements

- Use local reviewed V430NZ rows only.
- Preserve all source_reference and observed_at fields.
- Write only isolated stage artifacts.
- If any DATA_BRIDGE, UI, active payload, Steam fetch, BUFF fetch, BUY/TRADE, or trade/order path appears, stop immediately.

## Draft Approval Phrase

$ApprovalPhrase
"@
Set-Content -Encoding UTF8 -LiteralPath $PacketPath -Value $Packet

$Proof = @"
V430OA no-fetch/no-EV/no-DATA_BRIDGE/no-UI/no-buy-trade proof.

steam_mature_loop_isolated_ev_feed_authorization_packet_created=true
final_target_pool_rows=$($TargetRows.Count)
mature_source_rows_for_ev_feed=$($MatureRows.Count)
isolated_ev_handoff_ready_rows=$($HandoffRows.Count)
feed_input_compatibility_review_pass=$compatPass
feed_execution_performed=false
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
  status = $Status
  decision = $Decision
  project_root_confirmed = $true
  faictory_touched = $false
  v430nz_latest_loaded = $true
  v430nz_report_loaded = $true
  v430nz_proof_loaded = $true
  steam_mature_loop_isolated_ev_feed_authorization_packet_created = $true
  final_target_pool_rows = $TargetRows.Count
  mature_source_rows_for_ev_feed = $MatureRows.Count
  isolated_ev_handoff_ready_rows = $HandoffRows.Count
  feed_input_compatibility_review_pass = $compatPass
  feed_execution_performed = $false
  ready_for_user_approval_of_steam_mature_loop_isolated_ev_feed_execution = $true
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
  steam_mature_loop_ev_feed_authorization_packet = $PacketPath
  steam_mature_loop_ev_feed_approval_phrase = $ApprovalPhrase
  report_json = $ReportPath
  latest_json = $LatestPath
  no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof = $ProofPath
  footprint = $FootprintPath
  git_raw_footprint = $GitRawPath
  git_summary = $GitSummaryPath
  executed_script = $ScriptPath
  executed_script_sha256 = $ScriptHash
  next_safe_step = $NextSafeStep
}
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $ReportPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $LatestPath
$Report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $StageLatestPath

$Footprint = @"
# V430OA Local Footprint

Stage: $StageName
Status: $Status
Decision: $Decision
Report JSON: $ReportPath
Latest JSON: $LatestPath
Proof: $ProofPath
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash

Created artifacts:
- $PacketPath
- $ReadyRowsPath
- $InputMapPath
- $MatrixPath
- $BoundaryPath
- $PhrasePath
- $ProofPath

Safety summary: authorization only; no feed execution, no Steam fetch, no BUFF fetch, no EV, no DATA_BRIDGE, no active payload, no UI, no BUY_NOW, no TRADEUP_NOW, no trade/order, no FAICTORY touch.
"@
Set-Content -Encoding UTF8 -LiteralPath $FootprintPath -Value $Footprint
Set-Content -Encoding UTF8 -LiteralPath $GitRawPath -Value "V430OA git raw footprint initialized before controlled sync.`n"
$GitSummary = @"
# V430OA Git Summary

Stage: $StageName
Status: $Status
Decision: $Decision
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash

Git commit succeeded: pending
Git push succeeded: pending
Head matches origin: pending
Worktree clean: pending

Safety summary: authorization only; no feed execution, no fetch, no EV, no DATA_BRIDGE, no UI, no active payload, no buy/trade.
"@
Set-Content -Encoding UTF8 -LiteralPath $GitSummaryPath -Value $GitSummary

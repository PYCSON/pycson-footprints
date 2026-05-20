# V430OW executed script record
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$Latest = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ov_live_ui_navigation_refinement_closeout_or_hold_latest.json'
$Report = Join-Path $ProjectRoot '1047_V430OV_LIVE_UI_NAVIGATION_REFINEMENT_CLOSEOUT_OR_HOLD\V430OV_LIVE_UI_NAVIGATION_REFINEMENT_CLOSEOUT_OR_HOLD_20260520_090000\03_REPORT\v430ov_live_ui_navigation_refinement_closeout_or_hold_report.json'
$Proof = Join-Path $ProjectRoot '1047_V430OV_LIVE_UI_NAVIGATION_REFINEMENT_CLOSEOUT_OR_HOLD\V430OV_LIVE_UI_NAVIGATION_REFINEMENT_CLOSEOUT_OR_HOLD_20260520_090000\02_PROOF\no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
Get-Content -Raw -LiteralPath $Latest
Get-Content -Raw -LiteralPath $Report
Get-Content -Raw -LiteralPath $Proof

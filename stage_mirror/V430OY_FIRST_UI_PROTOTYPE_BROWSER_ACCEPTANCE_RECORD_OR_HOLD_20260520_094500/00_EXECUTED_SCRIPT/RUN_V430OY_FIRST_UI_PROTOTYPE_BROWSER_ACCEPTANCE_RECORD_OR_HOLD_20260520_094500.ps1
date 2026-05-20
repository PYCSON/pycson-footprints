# V430OY executed script record
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$Latest = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ox_live_ui_first_prototype_user_acceptance_check_or_hold_latest.json'
$Report = Join-Path $ProjectRoot '1049_V430OX_LIVE_UI_FIRST_PROTOTYPE_USER_ACCEPTANCE_CHECK_OR_HOLD\V430OX_LIVE_UI_FIRST_PROTOTYPE_USER_ACCEPTANCE_CHECK_OR_HOLD_20260520_093000\03_REPORT\v430ox_live_ui_first_prototype_user_acceptance_check_or_hold_report.json'
Get-Content -Raw -LiteralPath $Latest
Get-Content -Raw -LiteralPath $Report

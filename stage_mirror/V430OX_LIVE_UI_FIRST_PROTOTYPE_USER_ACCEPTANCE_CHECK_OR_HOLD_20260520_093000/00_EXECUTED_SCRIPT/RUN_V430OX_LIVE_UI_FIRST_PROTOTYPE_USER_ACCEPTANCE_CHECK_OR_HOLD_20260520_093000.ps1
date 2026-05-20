# V430OX executed script record
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$Latest = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ow_navigation_refinement_milestone_footprint_and_git_consolidation_or_hold_latest.json'
$Report = Join-Path $ProjectRoot '1048_V430OW_NAVIGATION_REFINEMENT_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD\V430OW_NAVIGATION_REFINEMENT_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_091500\04_REPORT\v430ow_navigation_refinement_milestone_footprint_and_git_consolidation_or_hold_report.json'
$MotherUi = Join-Path $ProjectRoot '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html'
$LiveUi = Join-Path $ProjectRoot '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html'
Get-Content -Raw -LiteralPath $Latest
Get-Content -Raw -LiteralPath $Report
Get-FileHash -Algorithm SHA256 -LiteralPath $MotherUi
Get-FileHash -Algorithm SHA256 -LiteralPath $LiveUi

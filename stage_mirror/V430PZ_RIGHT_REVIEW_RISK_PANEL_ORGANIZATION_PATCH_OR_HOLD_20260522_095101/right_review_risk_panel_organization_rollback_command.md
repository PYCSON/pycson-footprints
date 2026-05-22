# V430PZ Rollback Command

To rollback the V430PZ LIVE UI right review/risk panel organization patch, restore the backup:

`powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1084_V430PZ_RIGHT_REVIEW_RISK_PANEL_ORGANIZATION_PATCH_OR_HOLD\V430PZ_RIGHT_REVIEW_RISK_PANEL_ORGANIZATION_PATCH_OR_HOLD_20260522_095101\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PZ_20260522_095101.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
`

This rollback restores only V200_MASTER_UI_LIVE.html to the pre-V430PZ state. Mother UI is not touched.

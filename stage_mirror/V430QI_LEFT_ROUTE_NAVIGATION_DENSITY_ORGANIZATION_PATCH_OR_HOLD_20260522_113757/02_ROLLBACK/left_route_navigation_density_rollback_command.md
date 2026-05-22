# V430QI Rollback Command

To rollback V430QI, restore the LIVE UI from backup:

`powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1093_V430QI_LEFT_ROUTE_NAVIGATION_DENSITY_ORGANIZATION_PATCH_OR_HOLD\V430QI_LEFT_ROUTE_NAVIGATION_DENSITY_ORGANIZATION_PATCH_OR_HOLD_20260522_113757\01_BACKUP\V200_MASTER_UI_LIVE_before_V430QI_20260522_113757.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
`

This restores V200_MASTER_UI_LIVE.html to the exact pre-V430QI backup. Mother UI is not involved.

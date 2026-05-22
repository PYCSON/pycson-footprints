# V430QN Rollback Command

To rollback V430QN, restore the LIVE UI from backup:

`powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1099_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD\V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD_20260522_131046\01_BACKUP\V200_MASTER_UI_LIVE_before_V430QN_20260522_131046.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
`

This restores V200_MASTER_UI_LIVE.html to the exact pre-V430QN backup. Mother UI is not involved.

# V430PT Rollback Command

Run from PowerShell if rollback is required:

`powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1075_V430PT_MANUAL_REFRESH_UI_STATUS_DISPLAY_PATCH_EXECUTION_OR_HOLD\V430PT_MANUAL_REFRESH_UI_STATUS_DISPLAY_PATCH_EXECUTION_OR_HOLD_20260522_075037\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PT_20260522_075037.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
`

This restores the backed-up LIVE UI file. Mother UI was not modified by V430PT.

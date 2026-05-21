# V430PF Rollback Command

Run only if explicit rollback is required:

`powershell
Copy-Item -LiteralPath 'C:\Users\sunpu\Desktop\pycson\1060_V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD\V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD_20260521_141249\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PF.html' -Destination 'C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html' -Force
`

Rollback restores V200_MASTER_UI_LIVE.html from the V430PF backup. Mother UI is not part of rollback because it was not modified.

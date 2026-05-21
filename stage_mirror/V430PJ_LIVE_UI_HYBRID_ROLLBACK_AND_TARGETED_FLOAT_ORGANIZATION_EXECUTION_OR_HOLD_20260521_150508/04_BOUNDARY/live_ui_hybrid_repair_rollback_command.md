# V430PJ Rollback Command

Run only if explicit rollback is required:

`powershell
Copy-Item -LiteralPath 'C:\Users\sunpu\Desktop\pycson\1065_V430PJ_LIVE_UI_HYBRID_ROLLBACK_AND_TARGETED_FLOAT_ORGANIZATION_EXECUTION_OR_HOLD\V430PJ_LIVE_UI_HYBRID_ROLLBACK_AND_TARGETED_FLOAT_ORGANIZATION_EXECUTION_OR_HOLD_20260521_150508\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PJ_hybrid_repair.html' -Destination 'C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html' -Force
`

This restores the LIVE UI to the state immediately before V430PJ. Mother UI is not part of rollback because it was not modified.

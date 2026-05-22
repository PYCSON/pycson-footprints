# V430QD Rollback Command

To rollback the V430QD LIVE UI right dock compact repair patch, restore the backup:

`powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1088_V430QD_RIGHT_DOCK_LEGACY_SEALED_COMPACT_REPAIR_PATCH_OR_HOLD\V430QD_RIGHT_DOCK_LEGACY_SEALED_COMPACT_REPAIR_PATCH_OR_HOLD_20260522_102952\02_BACKUP\V200_MASTER_UI_LIVE_before_V430QD_20260522_102952.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
`

This rollback restores only V200_MASTER_UI_LIVE.html to the pre-V430QD state. Mother UI is not touched.

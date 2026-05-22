# V430PW LIVE UI Layout Zone Scaffold Rollback

To rollback V430PW only, restore the backed-up LIVE UI file:

```powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1079_V430PW_LIVE_UI_LAYOUT_ZONE_SCAFFOLD_PATCH_OR_HOLD\V430PW_LIVE_UI_LAYOUT_ZONE_SCAFFOLD_PATCH_OR_HOLD_20260522_083339\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PW_20260522_083339.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
```

This rollback restores the pre-V430PW LIVE UI snapshot. Do not modify Mother UI.

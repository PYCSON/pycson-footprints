# V430ON LIVE UI Button Entry Rollback Command

To rollback the V430ON button-entry patch, restore the timestamped backup over LIVE UI with a non-destructive copy:

```powershell
Copy-Item -LiteralPath "C:\Users\sunpu\Desktop\pycson\1039_V430ON_LIVE_UI_STEAM_MATURE_LOOP_BUTTON_ENTRY_PATCH_EXECUTION_OR_HOLD\V430ON_LIVE_UI_STEAM_MATURE_LOOP_BUTTON_ENTRY_PATCH_EXECUTION_OR_HOLD_20260520_070000\01_BACKUP\V200_MASTER_UI_LIVE_BACKUP_20260520_070000.html" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
```

Do not use git reset, git clean, git rm, force push, or deletion.

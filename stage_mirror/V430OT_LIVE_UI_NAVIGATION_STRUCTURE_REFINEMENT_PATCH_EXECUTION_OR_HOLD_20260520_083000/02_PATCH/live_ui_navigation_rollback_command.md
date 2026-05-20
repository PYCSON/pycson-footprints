# V430OT LIVE UI rollback command

Run only if rollback is explicitly required:

```powershell
Copy-Item -LiteralPath 'C:\Users\sunpu\Desktop\pycson\1045_V430OT_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_PATCH_EXECUTION_OR_HOLD\V430OT_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_PATCH_EXECUTION_OR_HOLD_20260520_083000\01_BACKUP\V200_MASTER_UI_LIVE.before_v430ot_20260520_083000.html' -Destination 'C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html' -Force
```

This restores the backed-up V200_MASTER_UI_LIVE.html. It does not modify V200_MASTER_UI.html.

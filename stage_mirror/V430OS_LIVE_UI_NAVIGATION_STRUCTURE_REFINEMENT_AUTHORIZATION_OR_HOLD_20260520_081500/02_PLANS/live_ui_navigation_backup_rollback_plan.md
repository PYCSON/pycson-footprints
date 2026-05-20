# LIVE UI Navigation Backup Rollback Plan

Before V430OT patch execution, copy V200_MASTER_UI_LIVE.html to a timestamped backup inside the V430OT stage folder. Record SHA256 before and after patch.

Rollback command shape:

```powershell
Copy-Item -LiteralPath "<V430OT_BACKUP_PATH>" -Destination "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html" -Force
```

Do not use git reset, git clean, git rm, force push, or deletion. V200_MASTER_UI.html remains protected and must not be modified.

# Backup and rollback plan

Before any later V430OZ patch, copy C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html to a timestamped backup under the V430OZ stage folder. Record SHA256 for mother UI, LIVE UI before patch, backup, and LIVE UI after patch. Rollback command must copy the backup file back over V200_MASTER_UI_LIVE.html. Mother UI must never be modified.

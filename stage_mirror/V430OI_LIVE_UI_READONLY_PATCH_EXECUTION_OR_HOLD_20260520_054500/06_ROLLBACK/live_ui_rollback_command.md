# LIVE UI rollback command

Run this only if V430OJ review requires rollback:

``powershell
Copy-Item -LiteralPath 'C:\Users\sunpu\Desktop\pycson\1034_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD\V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD_20260520_054500\02_BACKUP\V200_MASTER_UI_LIVE.before_V430OI_20260520_054500.html' -Destination 'C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html' -Force
``

Expected restored SHA256: 4989591FB6C18C0A6DFCB56F2C36F9164E302D1201FDC7C9D432101FD07D4703
No git reset, no git clean, no deletion required.

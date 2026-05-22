# V431G Rollback Command

To rollback V431G, restore the backup to LIVE UI:

``powershell
Copy-Item -LiteralPath 'C:\Users\sunpu\Desktop\pycson\1113_V431G_STEAM_WORKSPACE_HASH_ROUTE_PATCH_EXECUTION_OR_HOLD\V431G_STEAM_WORKSPACE_HASH_ROUTE_PATCH_EXECUTION_OR_HOLD_20260523_064548\01_BACKUP\V200_MASTER_UI_LIVE_before_V431G_20260523_064548.html' -Destination 'C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html' -Force
``

Mother UI is not modified by V431G.

# V430PE Second-Pass Backup And Rollback Plan

V430PE is authorization only. No backup or patch is executed in this stage.

Required later V430PF sequence after explicit approval:
1. Confirm mother UI and LIVE UI paths.
2. Record pre-patch hash for V200_MASTER_UI.html and V200_MASTER_UI_LIVE.html.
3. Backup V200_MASTER_UI_LIVE.html into the V430PF stage folder before any patch.
4. Patch V200_MASTER_UI_LIVE.html only.
5. Verify Steam Mature Loop module and STEAM MATURE LOOP button remain present.
6. Verify no DATA_BRIDGE, active payload, EV, fetch, BUY_NOW, TRADEUP_NOW, trade, or order behavior is added.
7. Create rollback command copying the backup over V200_MASTER_UI_LIVE.html only if rollback is explicitly needed.

Mother UI rollback is not applicable because mother UI must not be modified.

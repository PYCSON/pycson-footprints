# V430PI Hybrid Repair Backup And Rollback Plan

V430PI is authorization-only. No rollback and no patch are executed here.

Required later V430PJ sequence after explicit user approval:
1. Confirm LIVE UI and mother UI paths.
2. Record current LIVE UI hash and mother UI hash.
3. Backup current LIVE UI before restoring anything.
4. Restore rollback source candidate to V200_MASTER_UI_LIVE.html.
5. Apply only targeted float organization.
6. Verify Steam Mature Loop module and button are preserved.
7. Verify cockpit identity and visible richness are restored.
8. Verify no DATA_BRIDGE, active payload, EV, Steam/BUFF fetch, BUY_NOW, TRADEUP_NOW, trade, or order behavior is added.
9. Create rollback command to restore the pre-V430PJ backup if repair fails.

Rollback source candidate:
C:\Users\sunpu\Desktop\pycson\1060_V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD\V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD_20260521_141249\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PF.html

Rollback source SHA256:
25be8317d69d119e82f9268acd82148458fde59101ec7c664fa93114e94caceb

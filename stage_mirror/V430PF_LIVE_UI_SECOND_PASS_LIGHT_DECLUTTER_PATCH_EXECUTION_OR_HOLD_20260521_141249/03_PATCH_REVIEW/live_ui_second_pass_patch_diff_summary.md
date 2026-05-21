# V430PF Patch Diff Summary

Patched file: C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html
Backup file: C:\Users\sunpu\Desktop\pycson\1060_V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD\V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD_20260521_141249\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PF.html
Patch method: controlled apply_patch insertion before closing body tag.
Patch marker: PYCSON_V430PF_SECOND_PASS_LIGHT_DECLUTTER
Module count added: 1
Live UI hash before: 25be8317d69d119e82f9268acd82148458fde59101ec7c664fa93114e94caceb
Live UI hash after: 3c3c24cdbedd9f7417c412e50fb659dda014921036be32532a4094de8bf64944
Mother UI hash after: 9e51af6236261b096d4efd15de6caf97d23475e52bdb77b480b4614ffc250ba6

Structural changes:
- Added CSS class body.pycson-v430pf-second-pass-light-declutter.
- Added CSS overrides to reduce V418 card footprint and move it away from the left route directory.
- Added CSS overrides to collapse L2R2 refined display content by default.
- Added CSS overrides for compact Risk Monitor and Offline Replay minimized states.
- Added script to apply the V430PF class and preservation attributes after DOM load.
- Added default minimized state for right-side Risk Monitor and Offline Replay cards.
- Preserved Steam Mature Loop module and button with data-v430pf-preserved=true.

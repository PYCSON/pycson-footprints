# V430OT LIVE UI navigation patch diff summary

Patched file: C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html
Backup file: C:\Users\sunpu\Desktop\pycson\1045_V430OT_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_PATCH_EXECUTION_OR_HOLD\V430OT_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_PATCH_EXECUTION_OR_HOLD_20260520_083000\01_BACKUP\V200_MASTER_UI_LIVE.before_v430ot_20260520_083000.html

Change summary:
- Added one self-contained V430OT readonly route directory block.
- Added 10 route family entries: Steam Mature Loop, Trade-up, EV / Trusted EV, Risk, Records / Proof, Params / Config, Radar / Discovery, File / Footprint, Scheduler / Cadence, DATA_BRIDGE / UI.
- Added one safe focus/highlight function: pycsonV430OTFocusRoute(route).
- Preserved existing V430ON STEAM MATURE LOOP entry.
- Preserved existing V430OI Steam Mature Loop readonly module.
- No mother UI modification.
- No DATA_BRIDGE write, active payload write, EV calculation, Steam/BUFF fetch, BUY_NOW, TRADEUP_NOW, or trade/order trigger.

Pre-patch LIVE UI SHA256: 2805E2EDCB04EAF6761549FD53C686B8210CC9E1E0AA8F21755579072BA5A083
Post-patch LIVE UI SHA256: 5269EF688C9CE7629C73C8D409BA37AAD5BF317BBB5B5C043543D31521CA957B
Mother UI SHA256: 9E51AF6236261B096D4EFD15DE6CAF97D23475E52BDB77B480B4614FFC250BA6

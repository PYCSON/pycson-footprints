# Steam mature loop UI readonly display route plan

Stage: V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD

This stage plans the first real usable UI route for the completed Steam mature loop. It is planning only. It confirms the existing mother UI and LIVE UI paths, but it does not modify either file. It does not write DATA_BRIDGE, active payload, or any UI payload. It does not calculate EV. It does not fetch Steam or BUFF. It does not issue BUY_NOW, TRADEUP_NOW, or trade/order.

## Existing UI boundary

- Mother UI confirmed: C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html
- LIVE UI confirmed: C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html
- Mother UI modification allowed in this stage: false
- LIVE UI patch allowed in this stage: false
- New standalone replacement UI allowed: false

## Route shape

1. Build an isolated readonly UI payload candidate in the next stage.
2. Review the payload candidate against V430OD final closeout artifacts.
3. Create a controlled LIVE UI patch authorization packet after payload review.
4. Only after explicit future authorization, patch the existing LIVE UI with a reversible readonly display section.
5. Keep mother UI untouched unless a separate future mother UI authorization is explicitly created.

## Intended display

The readonly display should show Steam mature loop frozen status, seven final target rows, five excluded failed targets, runner policy badges, screening statuses, isolated EV handoff readiness, feed execution/review status, and boundary warnings. All display content must be informational only.

## Boundary warnings to show in UI

- No DATA_BRIDGE write.
- No BUY_NOW.
- No TRADEUP_NOW.
- No trade/order.
- No official EV or trusted EV calculation in the UI route.
- No Steam or BUFF fetch from UI.

# V430QH Recommended Next UI Zone Plan

## Status

V430QD/V430QG confirmed the right dock compact repair visually successful. This stage is planning only and performs no UI patch.

## Recommended Next Zone

Recommended next zone: **Left Route Directory / V418 local source candidate density organization**.

Recommended next stage name: V430QI_LEFT_ROUTE_NAVIGATION_DENSITY_ORGANIZATION_PATCH_OR_HOLD.

## Rationale

The user screenshot evidence leaves the left Route Directory / V418 local source candidate area as the most meaningful remaining navigation-density issue. A narrow patch can improve scanability and navigation grouping while preserving the Route Directory and all existing accessible modules.

Bottom and legacy floating panels still compete visually, but they are broader and more likely to spill into multiple regions. Risk Monitor / Offline Replay compact grouping is not urgent because those elements were preserved and the right dock repair is now accepted.

## Allowed Patch Scope For V430QI

- Patch V200_MASTER_UI_LIVE.html only after backup.
- Touch only the left route/navigation density area and V418 local source candidate density presentation if possible.
- Add small labels, grouping wrappers, spacing rules, or compact section structure.
- Preserve all route entries and accessible module links.
- Preserve current active route, Steam Mature Loop, V430PT status, right dock, Risk Monitor, Offline Replay, bottom dock, theme controls, and mother identity.
- Create rollback command and post-patch screenshot/browser evidence requirement.

## Forbidden Patch Scope For V430QI

- Do not patch V200_MASTER_UI.html.
- Do not remove, hide, rename, or move Route Directory entries.
- Do not remove, hide, rename, or move legacy/archive modules.
- Do not touch Steam Mature Loop center module.
- Do not touch right dock unless preservation check only.
- Do not touch bottom dock unless preservation check only.
- Do not replace the cockpit or perform global declutter.
- Do not write DATA_BRIDGE or active payload.
- Do not fetch, calculate EV, buy, trade, tradeup, or order.

## Rollback Expectations

V430QI must create a timestamped backup of V200_MASTER_UI_LIVE.html and a direct rollback command before patching. Rollback should restore the prior live UI file exactly from backup.

## Screenshot Evidence Requirement After Patch

After V430QI, browser or user screenshot evidence must confirm left navigation density improved while Route Directory, Steam Mature Loop, V430PT status, right dock, bottom dock, theme controls, and mother identity remain preserved.

## PASS / HOLD / STOP Conditions For V430QI

PASS only if the left route/navigation density patch is narrow, visible functions remain accessible, boundaries remain closed, and Git sync succeeds.

HOLD if the patch cannot be kept to the left navigation/V418 density area, if visual evidence is insufficient, or if Git export is blocked.

STOP if Mother UI is modified, DATA_BRIDGE or active payload is written, EV/fetch/buy/trade/order occurs, FAICTORY is touched, or critical UI functionality is hidden/removed.

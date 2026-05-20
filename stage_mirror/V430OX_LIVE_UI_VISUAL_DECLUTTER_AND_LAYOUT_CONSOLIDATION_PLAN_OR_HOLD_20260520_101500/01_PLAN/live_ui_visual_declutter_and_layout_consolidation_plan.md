# V430OX LIVE UI visual declutter and layout consolidation plan

This is planning only. No LIVE UI patch, mother UI modification, DATA_BRIDGE write, active payload write, EV calculation, Steam fetch, BUFF fetch, BUY_NOW, TRADEUP_NOW, or trade/order occurs in this stage.

## Design intent

The user confirmed the first UI route works, but the interface is still visually crowded. The next safe move is not another function and not another card. The next safe move is to consolidate layout hierarchy so the LIVE UI can scale. The cockpit should read as a route-driven application: top navigation for major families, left directory for route selection, center cockpit for the selected route, right side for risk and boundary alerts, and bottom zone for safe route-aware actions only.

## Proposed structure

1. Top navigation keeps major families only. STEAM MATURE LOOP remains visible, but it should be treated as a route entry rather than another noisy badge.
2. Left side becomes route/module directory. It should not be blocked by floating source cards. Local source candidate content should become collapsible or move under Source / Records.
3. Center cockpit becomes the selected route display. Steam Mature Loop should be promotable into the primary center route panel instead of being buried lower on the page.
4. Right side consolidates Risk, Boundary, and Alerts. Replay and Route Directory should not visually compete there unless collapsed.
5. Bottom action zone is safe actions only: navigate, focus, inspect, export proof, open local report. No BUY_NOW, TRADEUP_NOW, trade/order, hidden DATA_BRIDGE write, or hidden active payload write.
6. Legacy V197/V198/V200 modules remain preserved but become route-family panels or collapsible diagnostics. Nothing is deleted in the first declutter patch.

## Patch sequence recommendation

First authorization should permit a reversible LIVE UI patch that adds layout containers, collapsible wrappers, and route-zone labels while preserving all existing modules. Second review should confirm Steam Mature Loop is still visible and reachable. Later stages can refine visual polish after hierarchy is stable.

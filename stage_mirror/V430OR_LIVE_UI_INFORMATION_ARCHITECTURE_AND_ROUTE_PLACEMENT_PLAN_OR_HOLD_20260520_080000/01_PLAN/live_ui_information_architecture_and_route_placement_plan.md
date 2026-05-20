# LIVE UI Information Architecture And Route Placement Plan

Status: READY_FOR_V430OS_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_AUTHORIZATION_OR_HOLD
Decision: READY_FOR_V430OS_LIVE_UI_NAVIGATION_STRUCTURE_REFINEMENT_AUTHORIZATION_OR_HOLD

## Purpose
Organize the LIVE UI before more routes are added. The immediate goal is clarity, placement, module zones, navigation policy, and insertion rules rather than visual polish.

## Core Rule
V200_MASTER_UI.html remains the mother UI and must not be modified. V200_MASTER_UI_LIVE.html is the only future controlled patch target, and every patch requires backup, rollback, review, and footprint.

## Proposed Structure
- Top navigation: major route families only: Global, Trade-up, Risk, Records, Params, File, Radar, Steam Mature Loop, Scheduler, Integration.
- Left-side route directory: detailed route list and stage anchors, grouped by family.
- Central cockpit: selected route status, summary, key counters, and readonly proof links.
- Right panel: risk, boundary, alerts, and no-trade/no-write warnings.
- Bottom zone: safe actions only, such as scroll, filter, expand/collapse, open report, copy path, and review packet navigation.

## Placement Principle
No random card injection. A route must have a family, a zone, a payload/readiness source, a boundary policy, a rollback plan, and a review stage before it becomes part of LIVE UI.

## Steam Mature Loop Placement
The existing STEAM MATURE LOOP top-nav entry and readonly module should become the reference pattern: visible entry, stable anchor, central route card, source/proof links, explicit no DATA_BRIDGE/no trade boundary, and no active write side effects.

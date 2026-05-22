# V431E Steam Dedicated Workspace/Page Plan

Stage: V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD
Generated: 20260522_165800

This stage is planning-only. It does not patch UI, write DATA_BRIDGE, write active payload, fetch Steam or BUFF, call market endpoints, calculate EV, trade, order, or touch FAICTORY.

## Main Cockpit Responsibilities
- Remain the overview/dashboard and current operational cockpit.
- Keep current Steam Mature Loop overview card visible.
- Keep current top STEAM MATURE LOOP button visible.
- Keep Route Directory and module index visible.
- Show status and high-level review indicators without absorbing detailed Steam workflows.

## Steam Workspace Responsibilities
- Host detailed Steam workflow surfaces without making the main cockpit denser.
- Keep readonly universe/index review, mock fixture review, bounded scheduler planning, candidate screening planning, and proof/latest/report/git links in one bounded Steam-specific workspace.
- Preserve no-fetch, no-EV, no-trade posture visibly.
- Make future Steam work easier to review before any patch or execution.

## Required Entry Points
1. Top STEAM MATURE LOOP button.
2. Left Route Directory entry.
3. Steam overview card link labeled as an Open Steam Workspace style entry in a future patch.

## Design Options
- A. Hash route #steam-workspace: safest, reversible, no extra page file, keeps current page identity.
- B. Internal page switch data-page="steam": structured and scalable but slightly more implementation surface.
- C. Separate HTML page: clean separation but higher navigation/file consistency risk.
- D. No dedicated page: lowest immediate work but worsens future cockpit density.

## Recommendation
Recommend Option A first: hash route #steam-workspace, planned only. It is the smallest future UI patch surface and can be backed out easily. Option B can be considered later if workspace complexity grows.

# Steam Mature Loop Manual Refresh and UI Status Route Plan

Stage: V430PM_STEAM_MATURE_LOOP_MANUAL_REFRESH_AND_UI_STATUS_ROUTE_PLAN_OR_HOLD

This stage plans the first controlled route toward a manual user-triggered Steam mature loop refresh, followed by screening, isolated EV feed preparation, and a readonly UI status payload candidate. This is route planning only. It does not fetch Steam, fetch BUFF, calculate official EV, calculate trusted EV, write DATA_BRIDGE, write active payload, patch UI, or trade.

## 1. Manual Refresh Route Overview

The route begins from the existing frozen 7-target Steam mature pool. A user-triggered refresh stage may later run a public readonly, low-rate, cache-only Steam mature loop refresh under strict stop rules. The refresh would produce a local result package, then a screening package for stale/drift/liquidity/risk review, then an isolated feed-ready package for later EV handoff. UI changes remain readonly and require separate authorization.

Route shape:

1. Manual trigger chosen by user.
2. Load frozen 7-target pool and runner policy.
3. Execute only authorized public readonly low-rate cache-only refresh in a future stage.
4. Write refresh execution rows and price candidate rows in local outputs.
5. Screen stale/drift/liquidity/risk.
6. Prepare isolated EV feed-ready rows without calculating official/trusted EV.
7. Build UI readonly status payload candidate.
8. Later authorization may display readonly status in LIVE UI.

## 2. Trigger Options

PowerShell manual command is the safest first trigger because it is explicit, local, reversible, and easy to log. A local UI button can be considered later after route behavior is proven. Scheduled cadence is later still and must not begin until manual refresh, screening, UI status payload, and user acceptance are stable.

## 3. Required Inputs

The route requires the frozen 7-target mature pool, the current runner policy, cache-only output policy, and stop rules. No login, cookies, credentials, CAPTCHA bypass, anti-bot bypass, proxy/IP rotation, or hidden browser automation are allowed.

## 4. Required Outputs

The future refresh route should produce refresh execution rows, price candidate rows, screening rows, isolated EV feed-ready rows, and a UI status payload candidate. These outputs must remain local and auditable until explicit authorization moves them into any UI display or DATA_BRIDGE path.

## 5. UI Status Update Policy

The UI status payload candidate should contain last refresh time, success count, error count, stale/drift/risk summary, handoff-ready count, and boundary status. It must be readonly. It must not contain BUY_NOW, TRADEUP_NOW, trade/order, active payload write, DATA_BRIDGE write, or market action semantics.

## 6. Authorization Sequence

Recommended sequence:

1. V430PN manual refresh authorization packet.
2. V430PO manual refresh execution.
3. V430PP refresh screening review.
4. V430PQ UI status payload candidate.
5. V430PR UI status display authorization.

## 7. Failure Handling

If fewer than minimum target success rows are produced, hold for route repair and do not build feed-ready rows. If Steam blocks or challenges, stop immediately and record stop reason. If stale/drift risk is high, hold for review rather than promotion. If UI payload mismatch is detected, hold for payload contract repair.

## 8. Boundaries

This route is not full automation, not unattended cadence, and not auto-trading. It cannot write DATA_BRIDGE, write active payload, calculate official/trusted EV, fetch Steam/BUFF in this planning stage, patch UI, create BUY_NOW/TRADEUP_NOW, or trade/order.

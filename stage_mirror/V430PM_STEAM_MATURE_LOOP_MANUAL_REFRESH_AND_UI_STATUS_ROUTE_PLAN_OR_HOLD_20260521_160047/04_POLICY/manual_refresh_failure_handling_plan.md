# Manual Refresh Failure Handling Plan

- Fewer than minimum target success rows: hold route, record failed target IDs, do not create feed-ready rows.
- Steam block/challenge/CAPTCHA/login/cookie/credential/proxy requirement: stop immediately and record boundary stop. Do not bypass.
- Stale/drift/liquidity/risk high: hold for screening review and do not promote to feed-ready.
- UI status payload mismatch: hold for contract repair and do not write DATA_BRIDGE or active payload.
- Any BUY_NOW / TRADEUP_NOW / trade/order signal: stop as boundary breach.
- Any official/trusted EV calculation request in this route: hold for separate authorization.

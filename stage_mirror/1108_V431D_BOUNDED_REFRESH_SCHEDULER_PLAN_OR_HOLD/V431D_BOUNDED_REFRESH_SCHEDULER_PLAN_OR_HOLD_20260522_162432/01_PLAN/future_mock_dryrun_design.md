# Future Local Scheduler Mock Dryrun Design

A future V431F may test scheduler shape only against the V431C local mock fixture.

Allowed in future mock dryrun:
- Read local V431C mock rows.
- Apply scheduler state transitions locally.
- Emit dryrun-only status proposals such as MOCK_ONLY, LOCAL_ONLY, REVIEW_REQUIRED, BLOCKED, RATE_LIMIT_HOLD, and FETCH_NOT_AUTHORIZED.
- Produce a local dryrun report and proof.

Forbidden without later approval:
- Steam or BUFF fetch.
- Market endpoint call.
- DATA_BRIDGE write.
- Active payload write.
- EV calculation.
- Buy, trade, order, or trade-up execution.
- Background daemon or unattended loop.

Recommended mock cap: 4 fixture rows from V431C only.
Recommended output: local report rows with no live price and no executable value.

# LIVE UI rollback plan

Rollback for a future V430OI patch must restore V200_MASTER_UI_LIVE.html from the timestamped backup if any of the following occur:

- display route does not render,
- payload candidate cannot be read as readonly display data,
- boundary warnings are missing,
- any DATA_BRIDGE, active payload, EV, fetch, BUY_NOW, TRADEUP_NOW, or trade/order route appears,
- mother UI modification is detected.

Rollback must not use git reset or git clean. Restore from the explicit backup artifact and record proof.

# Allowed Readonly Refresh Scope

Allowed only in a future explicitly approved dryrun:
- Readonly metadata refresh route only.
- Bounded, single-window dryrun.
- No authentication, no account session, no cookies, no captcha solving, no proxy rotation, no region bypass.
- Outputs must be local dryrun artifacts only.
- Inputs must come from approved scheduler/candidate screening artifacts and explicit future readonly source allowlist.
- No DATA_BRIDGE write or active payload write.
- No UI patch.
- No EV, price recommendation, executable signal, buy, order, or trade action.

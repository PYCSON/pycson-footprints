# STOP / HOLD / PASS Conditions

## STOP
- Missing authorization review.
- Missing explicit future approval phrase.
- Any request for login, cookies, captcha, proxy, bypass, account automation, trade/order, EV, UI patch, DATA_BRIDGE write, active payload write, or cross-project access.

## HOLD
- Source allowlist incomplete.
- Future dryrun output schema unclear.
- Any ambiguity about whether a source access route is readonly.
- Any forbidden marker appears in outputs.

## PASS
- Future authorization review passes.
- Future approval phrase is confirmed.
- Future dryrun remains readonly/local-output-only.
- No fetch/write/EV/UI/trade boundary opens outside approved scope.

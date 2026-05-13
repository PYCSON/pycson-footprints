# PYCSON V430 to V500 BUFF-first Signal Loop Roadmap

Date: 20260513_195630

## V430B
BUFF-first local source schema review.

## V430C
BUFF raw cache candidate package.

## V430D
BUFF clean price pool dryrun.

## V430E
BUFF mapping review.

## V430F
BUFF source readiness gate.

## V430G
WATCH / REVIEW / SKIP dryrun.

## V430H
Controlled display bridge.

## V500
PYCSON Signal Loop Alpha.

Target loop:

- real or semi-real data enters system
- data is cleaned
- mapping is checked
- limited EV / ROI / risk dryrun runs
- WATCH / REVIEW / SKIP appears safely in UI
- audit trail is preserved

Big-loop challenges:

- platform-specific schemas
- BUFF / Steam price disagreements
- stale cache
- 0 price
- abnormal price
- currency mismatch
- item name mismatch
- wear mismatch
- StatTrak mismatch
- thin liquidity
- lowest listing price not equal to executable price
- API restrictions
- anti-bot behavior
- report files that look like price files
- UI payloads that contain prices but are not raw market data

# V430 BUFF-first Roadmap

Timestamp: 20260513_193734

This folder is the visible GitHub milestone folder for the V430 BUFF-first roadmap.

Current PYCSON status:

- V429 big-loop / refined UI closure completed.
- V430 readonly local / multi-source price pipeline started.
- V430A2 fixed inventory passed.
- Next technical stage: V430B_BUFF_FIRST_LOCAL_SOURCE_SCHEMA_REVIEW_OR_HOLD.

Meaning:

PYCSON is not starting live BUFF scraping yet. The next step is local BUFF-related source schema review:

1. Read V430A2 local inventory.
2. Filter BUFF / price / cache / clean source candidates.
3. Inspect headers and limited sample rows.
4. Classify raw cache / clean price pool / mapping / report-only / reject roles.
5. Keep all trading gates closed.

Still forbidden:

- No market fetch
- No Steam fetch
- No BUFF fetch
- No DATA_BRIDGE write
- No active payload write
- No UI patch
- No BUY_NOW
- No TRADEUP_NOW

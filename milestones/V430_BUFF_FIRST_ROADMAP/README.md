# V430 BUFF-first Roadmap

Date: 20260513_195630

## Why BUFF-first

BUFF is highly relevant to CS2 skin-market research, but PYCSON should not start live BUFF scraping immediately.

The first step is local and readonly:

- existing local files
- BUFF-related source filtering
- schema review
- limited sample review
- source role classification
- raw cache / clean price pool candidate decision

## V430B should do

- read V430A2 inventory, strong shortlist, and known clean local price hints
- filter BUFF / price / market / clean / raw / cache related files
- inspect file headers
- inspect limited sample rows
- classify source roles
- keep all trading gates closed

## V430B must not do

- no BUFF fetch
- no Steam fetch
- no market fetch
- no DATA_BRIDGE write
- no active payload write
- no UI patch
- no official EV
- no BUY_NOW
- no TRADEUP_NOW

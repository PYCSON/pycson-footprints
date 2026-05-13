# PYCSON Non-Trading Research Principles

Date: 20260513_195630

PYCSON is a non-trading research and decision-support system.

Closed gates:

- no auto trade
- no auto order
- no BUY_NOW
- no TRADEUP_NOW
- no real execution
- no market fetch
- no Steam fetch
- no BUFF fetch
- no DATA_BRIDGE write
- no active payload write
- no UI patch

Safety principles:

- A file with price in its name is not automatically a price source.
- A source candidate is not a trusted source.
- A clean-looking row is not necessarily clean data.
- Paper EV is not executable profit.
- WATCH / REVIEW is not BUY_NOW.

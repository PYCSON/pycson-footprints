# V431C Future Candidate Screening Readiness Notes

This fixture is suitable for planning-only future V431D/V431E work because it contains multiple safe local states: MOCK_ONLY, LOCAL_ONLY, REVIEW_REQUIRED, and BLOCKED.

Allowed future use:
- Validate local schema readers.
- Plan bounded scheduler dryrun inputs without fetching.
- Plan candidate screening statuses without EV or trading.

Forbidden without explicit future approval:
- Steam fetch or BUFF fetch.
- DATA_BRIDGE write or active payload write.
- Official/trusted/trade-up EV calculation.
- BUY_NOW, TRADEUP_NOW, trade, or order.
- Any live price, executable price, order book, liquidity-from-live-source, token, cookie, session, account, or proprietary mapping export.

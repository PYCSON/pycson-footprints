# Raw Footprint: V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD

STATUS: PASS_HOLD_V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_READY_NO_FETCH_NO_EV
DECISION: READY_FOR_V430ER_PROBABILITY_OUTPUT_POOL_EVIDENCE_GAP_REQUEST_PACKET_OR_HOLD
LATEST JSON: C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430eq_local_price_source_fallback_manual_input_packet_review_or_hold_latest.json
REPORT JSON: C:\Users\sunpu\Desktop\pycson\758_V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD\V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD_20260515_093338\09_REPORT\V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD_report.json
EXECUTED SCRIPT: C:\Users\sunpu\Desktop\pycson\00_EXECUTED_SCRIPT\RUN_V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD_20260515_093338.ps1
EXECUTED SCRIPT SHA256: 68847EA80C0B93B7106C2373322185465F22A6EA4E089FD7738E04895F01DD9F

Counts:
- packet plan review rows: 6
- field carry-forward review rows: 9
- usable price source review rows: 4
- missing probability/output_pool review rows: 4
- raw BUFF boundary guard review rows: 7

Safety:
- local price source fallback, not raw BUFF source
- price source cannot substitute probability evidence
- price source cannot substitute output_pool evidence
- fake evidence: false
- accepted evidence: false
- validated evidence: false
- official EV: false
- DATA_BRIDGE write: false
- active payload write: false
- UI patch: false
- BUFF/Steam/market/network fetch: false
- BUY_NOW / TRADEUP_NOW: false
- real evidence application: false
- core write: false
- trade/order: false

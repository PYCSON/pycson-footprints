# Raw Footprint: V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_OR_HOLD

STATUS: PASS_HOLD_V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_READY_NO_FETCH_NO_EV
DECISION: READY_FOR_V430EQ_LOCAL_PRICE_SOURCE_FALLBACK_MANUAL_INPUT_PACKET_REVIEW_OR_HOLD
LATEST JSON: C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430ep_local_price_source_fallback_to_manual_evidence_input_packet_plan_or_hold_latest.json
REPORT JSON: C:\Users\sunpu\Desktop\pycson\757_V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_OR_HOLD\V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_OR_HOLD_20260515_092818\09_REPORT\V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_OR_HOLD_report.json
EXECUTED SCRIPT: C:\Users\sunpu\Desktop\pycson\00_EXECUTED_SCRIPT\RUN_V430EP_LOCAL_PRICE_SOURCE_FALLBACK_TO_MANUAL_EVIDENCE_INPUT_PACKET_PLAN_OR_HOLD_20260515_092818.ps1
EXECUTED SCRIPT SHA256: EF047FFDD87749198C0B8112F62B8A4577CBFCAF48FDD24C11526C463EA90F87

Counts:
- packet plan rows: 6
- field carry forward rows: 9
- usable price source rows: 4
- missing probability/output_pool rows: 4
- raw BUFF boundary guard rows: 7

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

# Raw Footprint: V430EN_LOCAL_BUFF_SOURCE_FILE_INTAKE_DRYRUN_OR_HOLD

STATUS: PASS_HOLD_V430EN_LOCAL_PRICE_SOURCE_FALLBACK_ALIAS_INTAKE_DRYRUN_READY_NO_FETCH_NO_EV
DECISION: READY_FOR_V430EO_LOCAL_PRICE_SOURCE_FALLBACK_INTAKE_REVIEW_OR_HOLD
INPUT FILE: C:\Users\sunpu\Desktop\pycson\98_V384_LOCAL_CSV_PRICE_READER\V384B_REPAIR_SAFE_LOCAL_CSV_PRICE_READER_20260506_081358\v384b_deduped_local_price_table.csv
INPUT ROLE: LOCAL_PRICE_SOURCE_FALLBACK_NOT_RAW_BUFF_SOURCE
PARSED ROWS: 4
FIELD MAP READY: True
PRICE SOURCE READY: True
SOURCE TRUST PRECHECK: PASS_LOCAL_PRICE_SOURCE_FALLBACK_CANDIDATE_NO_FETCH_NOT_RAW_BUFF
LATEST JSON: C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430en_local_buff_source_file_intake_dryrun_or_hold_latest.json
REPORT JSON: C:\Users\sunpu\Desktop\pycson\755_V430EN_LOCAL_BUFF_SOURCE_FILE_INTAKE_DRYRUN_OR_HOLD\V430EN_LOCAL_BUFF_SOURCE_FILE_INTAKE_DRYRUN_OR_HOLD_20260515_083346\09_REPORT\V430EN_LOCAL_BUFF_SOURCE_FILE_INTAKE_DRYRUN_OR_HOLD_report.json
EXECUTED SCRIPT: C:\Users\sunpu\Desktop\pycson\00_EXECUTED_SCRIPT\RUN_V430EN_LOCAL_BUFF_SOURCE_FILE_INTAKE_DRYRUN_OR_HOLD_20260515_083346.ps1
EXECUTED SCRIPT SHA256: E91989BACC166A1E3D97ABC85A2BA06A8CA7B7247FD9A6B5F19C8BEE45ECC7CB

Alias mapping:
- skin_name -> item_name
- wear_tier -> wear
- price_cny -> price
- source_url_or_note/source_platform -> source_reference
- observed_at -> timestamp
- price_cny implies CNY as dryrun alias parser assumption, not raw BUFF proof

Safety:
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

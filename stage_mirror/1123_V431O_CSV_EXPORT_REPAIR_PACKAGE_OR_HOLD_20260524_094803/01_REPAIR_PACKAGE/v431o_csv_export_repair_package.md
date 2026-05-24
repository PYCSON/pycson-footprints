# V431O CSV Export Repair Package

Status: PASS_V431O_CSV_EXPORT_REPAIR_PACKAGE_READY_FOR_EXECUTION
Decision: READY_FOR_V431O_CSV_EXPORT_REPAIR_EXECUTION_OR_HOLD

## Purpose

Prepare a safe repair package for the V431O local/mock candidate screening CSV export format issue found during V431P review.

## Known Issue

V431P confirmed that the V431O JSON outputs, screening summary, validation report, forbidden output scan, and no-write proof are valid. The CSV files parse, but their columns are PowerShell object metadata columns such as `Count`, `IsReadOnly`, `Keys`, and `Values` instead of review-grade screening result columns.

## Repair Target

Future repair execution should regenerate only the derived CSV outputs from the already valid V431O JSON result, without rerunning the screening logic or changing classifications.

Target CSV files:
- mock_screening_result.csv
- review_required_rows.csv
- blocked_rows.csv

## Required Review-Grade Columns

- universe_record_id
- candidate_class
- screening_status
- review_reason
- blocked_reason
- source_type
- is_mock
- is_local_only
- is_blocked
- is_review_required
- is_signal_ready
- forbidden_output_present
- notes

## Allowed Future Repair Inputs

- Existing V431O `mock_screening_result.json`
- Existing V431O `screening_summary.json`
- Existing V431O validation and forbidden output scan
- V431P review findings

## Forbidden During Future Repair

- No V431O screening rerun unless explicitly authorized
- No Steam fetch
- No BUFF fetch
- No market endpoint call
- No DATA_BRIDGE write
- No active payload write
- No UI patch
- No EV calculation
- No BUY/TRADE/ORDER output

## Recommended Repair Method

1. Load the existing V431O `mock_screening_result.json`.
2. Select only the target review-grade columns.
3. Fill absent optional text fields with empty strings or safe explanatory notes.
4. Write the three CSV files using structured CSV export.
5. Re-run forbidden output scan on the regenerated CSVs.
6. Produce a repair validation report.
7. Preserve original JSON outputs and local evidence.

## Acceptance Conditions

- CSVs parse with the required review-grade columns.
- Row counts match the V431O JSON result and summary.
- Review-required and blocked CSV subsets match JSON flags.
- Forbidden executable outputs remain absent.
- No fetch/write/EV/UI/trade action occurs.

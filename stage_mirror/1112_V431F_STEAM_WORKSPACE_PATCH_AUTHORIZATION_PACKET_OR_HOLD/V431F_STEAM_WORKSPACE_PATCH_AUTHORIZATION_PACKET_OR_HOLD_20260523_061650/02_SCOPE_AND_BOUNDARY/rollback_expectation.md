# Future V431G Rollback Expectation

V431G must not execute unless user explicitly approves patch execution.

Before patch:
- Create timestamped backup of V200_MASTER_UI_LIVE.html.
- Record backup path in report/latest/proof.

Rollback:
- Provide an exact restore command from backup to V200_MASTER_UI_LIVE.html.
- Do not modify Mother UI.
- Do not delete local evidence.

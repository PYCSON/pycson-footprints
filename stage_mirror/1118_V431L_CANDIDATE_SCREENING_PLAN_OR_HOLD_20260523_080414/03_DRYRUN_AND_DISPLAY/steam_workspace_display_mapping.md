# Steam Workspace Display Mapping for Candidate Screening

Main cockpit behavior:
- Show only a compact summary when future screening artifacts exist.
- Do not add action buttons.
- Do not show executable recommendations.

Steam workspace behavior:
- May show a readonly screening queue in a future approved UI stage.
- Queue rows should show candidate class, screening status, reason code, stale/local/mock boundary, and review requirement.
- All rows remain NO_TRADE / NOT_SIGNAL_READY until a separate future authorization says otherwise.

Forbidden display:
- No BUY_NOW.
- No TRADEUP_NOW.
- No executable order/trade control.
- No executable profit signal.
- No TRUSTED_EV or OFFICIAL_EV.

Future stages:
- V431M_CANDIDATE_SCREENING_PLAN_REVIEW_OR_HOLD reviews this plan.
- V431N_LOCAL_MOCK_CANDIDATE_SCREENING_DRYRUN_PACKAGE_OR_HOLD may package a local/mock dryrun only after review.
- V431O_LOCAL_MOCK_SCREENING_DRYRUN_OR_HOLD may run local/mock screening only after explicit approval.

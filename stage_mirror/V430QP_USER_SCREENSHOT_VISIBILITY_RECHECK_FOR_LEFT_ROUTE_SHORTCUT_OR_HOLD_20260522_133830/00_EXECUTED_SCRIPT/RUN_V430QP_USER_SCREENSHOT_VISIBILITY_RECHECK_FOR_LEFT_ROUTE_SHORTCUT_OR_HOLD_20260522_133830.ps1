param([string]$Root,[string]$RunDir,[string]$Stamp,[string]$StageName)
$ErrorActionPreference='Stop'
$evidenceDir=Join-Path $RunDir '01_EVIDENCE'
$boundaryDir=Join-Path $RunDir '02_BOUNDARY'
$reportDir=Join-Path $RunDir '03_REPORT'
$gitDir=Join-Path $RunDir '04_GIT_FOOTPRINT'
$latestDir=Join-Path $Root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$wordsDir=Join-Path $Root 'words.cossp\V430QP_USER_SCREENSHOT_VISIBILITY_RECHECK_FOR_LEFT_ROUTE_SHORTCUT_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsDir | Out-Null
$evidenceRecord=Join-Path $evidenceDir 'user_screenshot_visibility_evidence_record.md'
$visibilityCsv=Join-Path $evidenceDir 'function_visibility_checklist.csv'
$densityCsv=Join-Path $evidenceDir 'remaining_density_issue_inventory.csv'
$recommendation=Join-Path $evidenceDir 'shortcut_index_acceptance_recommendation.md'
$proof=Join-Path $boundaryDir 'no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
$reportPath=Join-Path $reportDir 'v430qp_user_screenshot_visibility_recheck_for_left_route_shortcut_or_hold_report.json'
$latestPath=Join-Path $latestDir 'v430qp_user_screenshot_visibility_recheck_for_left_route_shortcut_or_hold_latest.json'
$footprint=Join-Path $wordsDir ('v430qp_user_screenshot_visibility_recheck_footprint_'+$Stamp+'.md')
$gitRaw=Join-Path $gitDir 'v430qp_git_raw_footprint.txt'
$gitSummary=Join-Path $gitDir 'v430qp_git_summary.md'
@"
# V430QP User Screenshot Visibility Evidence Record

Stage: $StageName
Generated: $Stamp

This record is text-only. The screenshot image is not exported.

Observed from user-provided screenshot after V430QN:
- Page loads visually.
- Top Status Zone visible.
- Left Route / Navigation Zone visible.
- Module Index / shortcut strip visible near left Route Directory.
- Shortcut entries visible for Route Directory, V418, Reports, Proof, Latest, Git/File.
- V418 local source candidate remains visible.
- Steam Mature Loop remains visible and clear.
- V430PT REVIEW_REQUIRED / PARTIAL_SCREENING status remains visible.
- Right dock compact repair remains preserved.
- Risk Monitor remains visible.
- Offline Replay remains visible.
- Bottom Safety / Audit Dock remains visible.
- Theme/status controls remain visible.
- Mother cockpit identity remains preserved.
- No obvious missing major function.

Evaluation:
- Module Index improves shortcut visibility.
- Function entries do not appear removed.
- Left side remains dense.
- V418 card remains somewhat compressed.
- Report/proof/latest/git access is more visible than before but remains compact.
- Next action should be stabilization / acceptance planning, not broad declutter or further compression.
"@ | Set-Content -LiteralPath $evidenceRecord -Encoding UTF8
$visibilityRows=@(
 [pscustomobject]@{item='Route Directory'; classification='VISIBLE_BUT_DENSE'; core=$true; missing_or_hidden=$false; notes='Visible but still dense in left navigation'},
 [pscustomobject]@{item='Module Index / Shortcut Strip'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible near left Route Directory with requested shortcuts'},
 [pscustomobject]@{item='All route entries'; classification='COMPACT_BUT_ACCESSIBLE'; core=$true; missing_or_hidden=$false; notes='Compact but accessible'},
 [pscustomobject]@{item='V418 local source candidate'; classification='VISIBLE_BUT_DENSE'; core=$true; missing_or_hidden=$false; notes='Visible but somewhat compressed'},
 [pscustomobject]@{item='Reports / Proof / Latest / Git/File access'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Shortcut access made more visible; still compact overall'},
 [pscustomobject]@{item='Steam Mature Loop'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible and clear'},
 [pscustomobject]@{item='V430PT status display'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='REVIEW_REQUIRED / PARTIAL_SCREENING status visible'},
 [pscustomobject]@{item='Risk Monitor'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible'},
 [pscustomobject]@{item='Offline Replay'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible'},
 [pscustomobject]@{item='Bottom safety dock'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible'},
 [pscustomobject]@{item='Theme/status controls'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Visible'},
 [pscustomobject]@{item='Mother cockpit identity'; classification='VISIBLE_AND_CLEAR'; core=$true; missing_or_hidden=$false; notes='Preserved'}
)
$visibilityRows | Export-Csv -LiteralPath $visibilityCsv -NoTypeInformation -Encoding UTF8
$densityRows=@(
 [pscustomobject]@{issue='Left side remains dense'; severity='medium'; rollback_required=$false; recommended_treatment='Stabilization / acceptance plan before any further UI patch'},
 [pscustomobject]@{issue='V418 card remains somewhat compressed'; severity='medium'; rollback_required=$false; recommended_treatment='Future micro-readability plan only if needed'},
 [pscustomobject]@{issue='Report/proof/latest/git access more visible but still compact'; severity='low'; rollback_required=$false; recommended_treatment='Accept shortcut improvement; avoid broad declutter'}
)
$densityRows | Export-Csv -LiteralPath $densityCsv -NoTypeInformation -Encoding UTF8
@"
# V430QP Shortcut / Index Acceptance Recommendation

Recommendation: accept the V430QN Module Index patch as helpful and preserve it.

Reasons:
- User screenshot confirms the Module Index / shortcut strip is visible and clear.
- No core function is confirmed missing or hidden.
- Route Directory, V418, Reports, Proof, Latest, Git/File access, Steam Mature Loop, V430PT status, Risk Monitor, Offline Replay, bottom dock, theme/status controls, and mother cockpit identity remain visible or accessible.
- Remaining issue is density, not loss.

Recommended action: create a stabilization / acceptance plan rather than another immediate patch.

Recommended next stage: V430QQ_LEFT_ROUTE_SHORTCUT_VISIBILITY_ACCEPTANCE_AND_UI_STABILIZATION_PLAN_OR_HOLD

Forbidden next direction: broad declutter, further compression, removal/hiding of modules, or replacement cockpit.
"@ | Set-Content -LiteralPath $recommendation -Encoding UTF8
@"
V430QP boundary/no-write proof
Stage: $StageName
Generated: $Stamp
Screenshot evidence recording only: true
Screenshot image exported: false
UI patch performed: false
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
Steam fetch: false
BUFF fetch: false
Official/trusted EV calculated: false
BUY_NOW / TRADEUP_NOW / trade/order executed: false
FAICTORY touched: false
Rollback needed: false
"@ | Set-Content -LiteralPath $proof -Encoding UTF8
$status='PASS_HOLD_V430QP_SCREENSHOT_VISIBILITY_RECHECK_ACCEPTED_SAFE_FOOTPRINT_EXPORT_APPROVAL_REQUIRED'
$decision='HOLD_FOR_USER_APPROVAL_OF_V430QP_SAFE_FOOTPRINT_EXPORT_BEFORE_V430QQ'
$report=[ordered]@{
 status=$status; decision=$decision; project_root_confirmed=$Root; current_anchor='V430QO_SAFE_FOOTPRINT_EXPORT_FINALIZATION_COMPLETE'; current_head='bd91f91';
 screenshot_evidence_recorded=$true; page_load_visually_confirmed=$true; module_index_shortcut_strip_visible=$true;
 route_directory_visibility='VISIBLE_BUT_DENSE'; all_route_entries_visibility='COMPACT_BUT_ACCESSIBLE'; v418_candidate_visibility='VISIBLE_BUT_DENSE'; reports_proof_latest_git_access_visibility='VISIBLE_AND_CLEAR';
 steam_mature_loop_visibility='VISIBLE_AND_CLEAR'; v430pt_status_display_visibility='VISIBLE_AND_CLEAR'; risk_monitor_visibility='VISIBLE_AND_CLEAR'; offline_replay_visibility='VISIBLE_AND_CLEAR'; bottom_safety_dock_visibility='VISIBLE_AND_CLEAR'; theme_status_controls_visibility='VISIBLE_AND_CLEAR'; mother_cockpit_identity_visibility='VISIBLE_AND_CLEAR';
 hard_to_find_items=@(); possibly_hidden_items=@(); missing_visually_items=@(); function_loss_regression_confirmed=$false; module_index_accepted=$true; rollback_needed=$false; repair_needed=$false;
 recommended_action='CREATE_STABILIZATION_ACCEPTANCE_PLAN_NOT_ANOTHER_IMMEDIATE_PATCH'; recommended_next_stage_name='V430QQ_LEFT_ROUTE_SHORTCUT_VISIBILITY_ACCEPTANCE_AND_UI_STABILIZATION_PLAN_OR_HOLD';
 report_json=$reportPath; latest_json=$latestPath; proof=$proof; footprint=$footprint; git_raw_footprint=$gitRaw; git_summary=$gitSummary;
 screenshot_evidence_record=$evidenceRecord; function_visibility_checklist=$visibilityCsv; remaining_density_issue_inventory=$densityCsv; shortcut_index_acceptance_recommendation=$recommendation;
 live_ui_modified=$false; mother_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; ev_fetch_buy_trade_order=$false; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending'; head=$null; origin_main=$null; head_matches_origin=$false; worktree_clean=$false; next_safe_step='V430QQ_LEFT_ROUTE_SHORTCUT_VISIBILITY_ACCEPTANCE_AND_UI_STABILIZATION_PLAN_OR_HOLD'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
@"
# V430QP Local Footprint

Status: $status
Decision: $decision

Text-only screenshot evidence recorded. No screenshot image exported. The V430QN Module Index is accepted as helpful. No missing or hidden core function is confirmed. Remaining left-side density should be handled by stabilization / acceptance planning, not immediate broad declutter.

Report: $reportPath
Latest: $latestPath
Proof: $proof
"@ | Set-Content -LiteralPath $footprint -Encoding UTF8
@"
V430QP git raw footprint
Stage: $StageName
Status: $status
Decision: $decision
Safe export: metadata, report, proof, text-only screenshot evidence summary, checklist, recommendation, git summaries.
Excluded: screenshot image files, full UI source, full UI backups, private artifacts.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430QP Git Summary

Stage: $StageName
Status: $status
Decision: $decision

Safety summary: screenshot evidence recording only. No UI patch. No DATA_BRIDGE, active payload, fetch, EV, BUY/TRADE/ORDER, or FAICTORY touch.

Next safe step: V430QQ_LEFT_ROUTE_SHORTCUT_VISIBILITY_ACCEPTANCE_AND_UI_STABILIZATION_PLAN_OR_HOLD
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
'created V430QP artifacts'
'RUN_DIR='+$RunDir
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proof
'FOOTPRINT='+$footprint
'GIT_RAW='+$gitRaw
'GIT_SUMMARY='+$gitSummary

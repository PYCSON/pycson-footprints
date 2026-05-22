param([string]$Root,[string]$RunDir,[string]$Stamp,[string]$StageName)
$ErrorActionPreference='Stop'
$planDir=Join-Path $RunDir '01_PLAN'
$boundaryDir=Join-Path $RunDir '02_BOUNDARY'
$reportDir=Join-Path $RunDir '03_REPORT'
$gitDir=Join-Path $RunDir '04_GIT_FOOTPRINT'
$latestDir=Join-Path $Root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$wordsDir=Join-Path $Root 'words.cossp\V430QQ_LEFT_ROUTE_SHORTCUT_VISIBILITY_ACCEPTANCE_AND_UI_STABILIZATION_PLAN_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsDir | Out-Null
$acceptanceMd=Join-Path $planDir 'ui_stabilization_acceptance.md'
$baselineCsv=Join-Path $planDir 'current_visible_module_baseline.csv'
$gateCsv=Join-Path $planDir 'future_ui_patch_gate_checklist.csv'
$deferredCsv=Join-Path $planDir 'deferred_ui_issue_list.csv'
$proof=Join-Path $boundaryDir 'no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
$reportPath=Join-Path $reportDir 'v430qq_left_route_shortcut_visibility_acceptance_and_ui_stabilization_plan_or_hold_report.json'
$latestPath=Join-Path $latestDir 'v430qq_left_route_shortcut_visibility_acceptance_and_ui_stabilization_plan_or_hold_latest.json'
$footprint=Join-Path $wordsDir ('v430qq_ui_stabilization_acceptance_footprint_'+$Stamp+'.md')
$gitRaw=Join-Path $gitDir 'v430qq_git_raw_footprint.txt'
$gitSummary=Join-Path $gitDir 'v430qq_git_summary.md'
@"
# V430QQ UI Stabilization Acceptance

Stage: $StageName
Generated: $Stamp

## UI Organization Cycle Summary

- V430PT added the readonly manual refresh status display for REVIEW_REQUIRED / PARTIAL_SCREENING and preserved no-trade boundaries.
- V430PW formalized layout zones without replacing the cockpit.
- V430PZ and V430QD organized and compacted the right review/risk/legacy sealed dock.
- V430QI organized left route density without removing route entries.
- V430QN added a compact visible Module Index / shortcut strip for Route Directory, V418, Reports, Proof, Latest, and Git/File access.
- V430QP screenshot evidence accepted the Module Index as helpful and found no missing, hidden, or hard-to-find core function.

## Current Accepted UI State

Clear and accepted:
- Module Index / shortcut strip is visible and clear.
- Reports / Proof / Latest / Git/File access is visible and clearer than before.
- Steam Mature Loop remains visible and clear.
- V430PT REVIEW_REQUIRED / PARTIAL_SCREENING status remains visible and clear.
- Risk Monitor, Offline Replay, bottom safety dock, theme/status controls, and mother cockpit identity remain visible and clear.

Dense but acceptable:
- Route Directory remains VISIBLE_BUT_DENSE.
- V418 local source candidate remains VISIBLE_BUT_DENSE.
- All route entries are COMPACT_BUT_ACCESSIBLE.

Must not be compressed further:
- Left Route Directory area.
- V418 candidate card.
- Report/proof/latest/git access.

Deferred:
- Any additional visual cleanup should wait for a new concrete screenshot-backed problem.
- No broad declutter should occur.

## Stabilization Gate

Future UI patching is allowed only when all are true:
- Screenshot evidence shows a concrete user-facing issue.
- User explicitly approves the specific patch stage.
- Patch scope touches only one or two regions.
- Backup and rollback are created first.
- No function, module, route entry, safety button, or shortcut is hidden, removed, or made hard to find.
- The patch is plan-first unless the issue is narrow and clearly reversible.

## Recommended Next Direction

Pause UI patching and return to core PYCSON engineering planning unless the user explicitly requests another UI patch.

Recommended next stage: V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_OR_HOLD

Alternative hold: HOLD_FOR_USER_DIRECTION_AFTER_UI_STABILIZATION
"@ | Set-Content -LiteralPath $acceptanceMd -Encoding UTF8
$baselineRows=@(
 [pscustomobject]@{module='Module Index / Shortcut Strip'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Accepted as helpful shortcut repair'},
 [pscustomobject]@{module='Route Directory'; visibility='VISIBLE_BUT_DENSE'; accepted=$true; compress_further=$false; note='Dense but acceptable; preserve prominence'},
 [pscustomobject]@{module='All route entries'; visibility='COMPACT_BUT_ACCESSIBLE'; accepted=$true; compress_further=$false; note='Do not remove or hide entries'},
 [pscustomobject]@{module='V418 local source candidate'; visibility='VISIBLE_BUT_DENSE'; accepted=$true; compress_further=$false; note='Facts remain visible; no further compression'},
 [pscustomobject]@{module='Reports / Proof / Latest / Git/File access'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Shortcut visibility improved'},
 [pscustomobject]@{module='Steam Mature Loop'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserve center module'},
 [pscustomobject]@{module='V430PT readonly status display'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='REVIEW_REQUIRED / PARTIAL_SCREENING preserved'},
 [pscustomobject]@{module='Risk Monitor'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserved'},
 [pscustomobject]@{module='Offline Replay'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserved'},
 [pscustomobject]@{module='Bottom safety dock'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserved'},
 [pscustomobject]@{module='Theme/status controls'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserved'},
 [pscustomobject]@{module='Mother cockpit identity'; visibility='VISIBLE_AND_CLEAR'; accepted=$true; compress_further=$false; note='Preserved'}
)
$baselineRows | Export-Csv -LiteralPath $baselineCsv -NoTypeInformation -Encoding UTF8
$gateRows=@(
 [pscustomobject]@{gate='screenshot_evidence_required'; required=$true; pass_condition='Concrete visual issue documented before patch'},
 [pscustomobject]@{gate='explicit_user_approval_required'; required=$true; pass_condition='User approves exact stage and scope'},
 [pscustomobject]@{gate='scope_one_or_two_regions_only'; required=$true; pass_condition='No broad/global declutter'},
 [pscustomobject]@{gate='backup_required'; required=$true; pass_condition='Backup exists before patch'},
 [pscustomobject]@{gate='rollback_required'; required=$true; pass_condition='Rollback command exists before patch'},
 [pscustomobject]@{gate='no_hidden_or_removed_functions'; required=$true; pass_condition='All current visible/access modules preserved'},
 [pscustomobject]@{gate='no_left_route_compression'; required=$true; pass_condition='Left route/V418/report access not compressed further'},
 [pscustomobject]@{gate='no_core_boundary_breach'; required=$true; pass_condition='No DATA_BRIDGE, payload, fetch, EV, BUY/TRADE/ORDER'}
)
$gateRows | Export-Csv -LiteralPath $gateCsv -NoTypeInformation -Encoding UTF8
$deferredRows=@(
 [pscustomobject]@{issue='Left Route Directory remains dense'; disposition='accepted_for_now'; future_action='Only plan-first readability stage if screenshot evidence demands it'},
 [pscustomobject]@{issue='V418 card remains dense'; disposition='accepted_for_now'; future_action='No further compression; possible readability plan only'},
 [pscustomobject]@{issue='Report/proof/latest/git area remains compact'; disposition='accepted_for_now'; future_action='Preserve Module Index; no immediate patch'},
 [pscustomobject]@{issue='General UI not perfect'; disposition='stabilize'; future_action='Pause UI patching; return to core system planning'}
)
$deferredRows | Export-Csv -LiteralPath $deferredCsv -NoTypeInformation -Encoding UTF8
@"
V430QQ boundary/no-write proof
Stage: $StageName
Generated: $Stamp
Acceptance/stabilization planning only: true
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
Legacy/archive moved or deleted: false
"@ | Set-Content -LiteralPath $proof -Encoding UTF8
$status='PASS_HOLD_V430QQ_UI_STABILIZATION_ACCEPTED_SAFE_FOOTPRINT_EXPORT_APPROVAL_REQUIRED'
$decision='HOLD_FOR_USER_APPROVAL_OF_V430QQ_SAFE_FOOTPRINT_EXPORT_BEFORE_NEXT_SCOPE'
$report=[ordered]@{
 status=$status; decision=$decision; project_root_confirmed=$Root; current_anchor='V430QP_SAFE_FOOTPRINT_EXPORT_FINALIZATION_COMPLETE'; current_head='cf8c4ea';
 ui_stabilization_accepted=$true; module_index_accepted=$true; function_loss_regression_closed=$true; rollback_needed=$false; repair_needed=$false;
 current_visible_module_baseline_created=$true; future_ui_patch_gate_checklist_created=$true; deferred_ui_issues_recorded=$true;
 no_ui_patch_performed=$true; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; ev_fetch_buy_trade_order=$false;
 recommended_next_direction='PAUSE_UI_PATCHING_AND_RETURN_TO_CORE_PYCSON_ENGINEERING_PLANNING'; recommended_next_stage_name='V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_OR_HOLD';
 report_json=$reportPath; latest_json=$latestPath; proof=$proof; footprint=$footprint; git_raw_footprint=$gitRaw; git_summary=$gitSummary;
 ui_stabilization_acceptance=$acceptanceMd; current_visible_module_baseline=$baselineCsv; future_ui_patch_gate_checklist=$gateCsv; deferred_ui_issue_list=$deferredCsv;
 git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending'; head=$null; origin_main=$null; head_matches_origin=$false; worktree_clean=$false;
 next_safe_step='V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_OR_HOLD'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
@"
# V430QQ Local Footprint

Status: $status
Decision: $decision

The recent UI organization cycle is accepted as a stable checkpoint. The Module Index patch is accepted. Function-loss concern is closed based on V430QP screenshot evidence. Remaining density is accepted for now and should not trigger immediate patching.

Recommended next direction: pause UI patching and return to core PYCSON engineering planning.

Report: $reportPath
Latest: $latestPath
Proof: $proof
"@ | Set-Content -LiteralPath $footprint -Encoding UTF8
@"
V430QQ git raw footprint
Stage: $StageName
Status: $status
Decision: $decision
Safe export: metadata, acceptance plan, baseline CSV, gate checklist, deferred issue list, proof, report, footprint, git summaries.
Excluded: screenshots, full UI source, full UI backups, private artifacts.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430QQ Git Summary

Stage: $StageName
Status: $status
Decision: $decision

Safety summary: acceptance/stabilization planning only. No UI patch. No DATA_BRIDGE, active payload, fetch, EV, BUY/TRADE/ORDER, FAICTORY touch, archive move, or deletion.

Next safe step: V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_OR_HOLD
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
'created V430QQ artifacts'
'RUN_DIR='+$RunDir
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proof
'FOOTPRINT='+$footprint
'GIT_RAW='+$gitRaw
'GIT_SUMMARY='+$gitSummary

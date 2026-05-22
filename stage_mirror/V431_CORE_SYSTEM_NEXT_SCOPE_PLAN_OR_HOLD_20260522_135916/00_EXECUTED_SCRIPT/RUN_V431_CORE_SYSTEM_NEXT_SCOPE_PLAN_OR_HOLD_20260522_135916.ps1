param([string]$Root,[string]$RunDir,[string]$Stamp,[string]$StageName)
$ErrorActionPreference='Stop'
$planDir=Join-Path $RunDir '01_PLAN'
$boundaryDir=Join-Path $RunDir '02_BOUNDARY'
$reportDir=Join-Path $RunDir '03_REPORT'
$gitDir=Join-Path $RunDir '04_GIT_FOOTPRINT'
$latestDir=Join-Path $Root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$wordsDir=Join-Path $Root 'words.cossp\V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsDir | Out-Null
$scopeCsv=Join-Path $planDir 'v431_candidate_core_scope_comparison.csv'
$planMd=Join-Path $planDir 'v431_recommended_core_next_scope_plan.md'
$boundaryCsv=Join-Path $planDir 'v431_required_boundary_checklist.csv'
$forbiddenCsv=Join-Path $planDir 'v431_forbidden_action_matrix.csv'
$proof=Join-Path $boundaryDir 'no_ui_no_databridge_no_payload_no_fetch_no_ev_no_trade_proof.txt'
$reportPath=Join-Path $reportDir 'v431_core_system_next_scope_plan_or_hold_report.json'
$latestPath=Join-Path $latestDir 'v431_core_system_next_scope_plan_or_hold_latest.json'
$footprint=Join-Path $wordsDir ('v431_core_system_next_scope_plan_footprint_'+$Stamp+'.md')
$gitRaw=Join-Path $gitDir 'v431_git_raw_footprint.txt'
$gitSummary=Join-Path $gitDir 'v431_git_summary.md'
$scopeRows=@(
 [pscustomobject]@{option='A';candidate='Steam readonly universe/index planning';engineering_value='high';dependency_readiness='medium_high';safety_risk='low';data_bridge_risk='low';ui_dependency='low';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD';recommendation='strong candidate after UI stabilization'},
 [pscustomobject]@{option='B';candidate='bounded auto-refresh scheduler planning';engineering_value='high';dependency_readiness='medium';safety_risk='medium';data_bridge_risk='medium';ui_dependency='low';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431B_BOUNDED_AUTO_REFRESH_SCHEDULER_PLANNING_OR_HOLD';recommendation='later after readonly universe/index plan'},
 [pscustomobject]@{option='C';candidate='candidate screening engine planning';engineering_value='high';dependency_readiness='medium';safety_risk='medium';data_bridge_risk='medium';ui_dependency='low';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431C_CANDIDATE_SCREENING_ENGINE_PLANNING_OR_HOLD';recommendation='depends on readonly universe/index definitions'},
 [pscustomobject]@{option='D';candidate='trusted EV dryrun engine planning';engineering_value='high';dependency_readiness='low_medium';safety_risk='high';data_bridge_risk='medium';ui_dependency='low';requires_fetch=$false;requires_ev_calculation=$true;planning_only_first=$true;recommended_next_stage_name='V431D_TRUSTED_EV_DRYRUN_ENGINE_PLANNING_OR_HOLD';recommendation='defer until pre-EV screening architecture stabilizes'},
 [pscustomobject]@{option='E';candidate='trade-up/alchemy rule + EV architecture inventory';engineering_value='medium_high';dependency_readiness='medium';safety_risk='medium_high';data_bridge_risk='medium';ui_dependency='low';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431E_TRADEUP_ALCHEMY_RULE_EV_ARCHITECTURE_INVENTORY_OR_HOLD';recommendation='useful audit, but less immediate than readonly universe/index'},
 [pscustomobject]@{option='F';candidate='DATA_BRIDGE integration readiness plan';engineering_value='high';dependency_readiness='low';safety_risk='high';data_bridge_risk='high';ui_dependency='medium';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431F_DATABRIDGE_INTEGRATION_READINESS_PLAN_OR_HOLD';recommendation='defer; too close to write boundary'},
 [pscustomobject]@{option='G';candidate='audit/handoff consolidation before new core work';engineering_value='medium';dependency_readiness='high';safety_risk='low';data_bridge_risk='low';ui_dependency='none';requires_fetch=$false;requires_ev_calculation=$false;planning_only_first=$true;recommended_next_stage_name='V431G_AUDIT_HANDOFF_CONSOLIDATION_BEFORE_CORE_WORK_OR_HOLD';recommendation='safe fallback, but V430QQ already stabilized UI handoff'}
)
$scopeRows | Export-Csv -LiteralPath $scopeCsv -NoTypeInformation -Encoding UTF8
$boundaryRows=@(
 [pscustomobject]@{boundary='planning_only';required=$true;note='V431 selects next scope only'},
 [pscustomobject]@{boundary='no_ui_patch';required=$true;note='No V200_MASTER_UI or LIVE UI modification'},
 [pscustomobject]@{boundary='no_databridge_write';required=$true;note='No DATA_BRIDGE writes or integration writes'},
 [pscustomobject]@{boundary='no_active_payload_write';required=$true;note='No payload replacement/write'},
 [pscustomobject]@{boundary='no_steam_or_buff_fetch';required=$true;note='No live network market fetch'},
 [pscustomobject]@{boundary='no_official_or_trusted_ev_calculation';required=$true;note='No EV calculation in V431'},
 [pscustomobject]@{boundary='no_buy_trade_order';required=$true;note='No BUY_NOW, TRADEUP_NOW, trade, order'},
 [pscustomobject]@{boundary='no_faictory_touch';required=$true;note='PYCSON only'}
)
$boundaryRows | Export-Csv -LiteralPath $boundaryCsv -NoTypeInformation -Encoding UTF8
$forbiddenRows=@('UI patch','V200_MASTER_UI.html modification','V200_MASTER_UI_LIVE.html modification','DATA_BRIDGE write','active payload write','Steam fetch','BUFF fetch','official EV calculation','trusted EV calculation','BUY_NOW','TRADEUP_NOW','trade/order','FAICTORY touch','force push','git reset','delete/move legacy/archive') | ForEach-Object { [pscustomobject]@{action=$_; forbidden=$true; occurred=$false} }
$forbiddenRows | Export-Csv -LiteralPath $forbiddenCsv -NoTypeInformation -Encoding UTF8
@"
# V431 Recommended Core Next Scope Plan

Stage: $StageName
Generated: $Stamp

## Context

V430 UI stabilization is accepted. UI patching should pause unless a new screenshot-backed issue is explicitly approved. PYCSON should return to core engineering planning without crossing fetch, EV, DATA_BRIDGE, payload, or trade boundaries.

## Comparison Result

The safest high-value next core direction is **Steam readonly universe/index planning**.

Why this is the recommended next scope:
- It has high engineering value and relatively low boundary risk.
- It can remain planning-only and local/read-only.
- It improves the foundation for later scheduler, screening, and EV dryrun work without performing fetches or calculations.
- It avoids DATA_BRIDGE writes and active payload writes.
- It is less risky than jumping directly to scheduler automation, trusted EV, or DATA_BRIDGE readiness.

## Recommended Next Stage

V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD

## Allowed Planning Scope

- Define readonly universe/index goals.
- List local source assumptions and index fields.
- Define no-fetch source boundaries.
- Define candidate classes and review statuses.
- Define later handoff needs for scheduler/screening without executing them.
- Produce planning artifacts, proofs, report/latest, and safe footprint only.

## Forbidden Actions

- No Steam/BUFF fetch.
- No official/trusted EV calculation.
- No DATA_BRIDGE write.
- No active payload write.
- No BUY_NOW, TRADEUP_NOW, trade, or order.
- No UI patch.
- No production automation.

## Next Safe Step

V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD
"@ | Set-Content -LiteralPath $planMd -Encoding UTF8
@"
V431 boundary/no-write proof
Stage: $StageName
Generated: $Stamp
Planning only: true
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
$status='PASS_HOLD_V431_CORE_SYSTEM_NEXT_SCOPE_PLAN_READY_SAFE_FOOTPRINT_EXPORT_APPROVAL_REQUIRED'
$decision='HOLD_FOR_USER_APPROVAL_OF_V431_SAFE_FOOTPRINT_EXPORT_BEFORE_V431A'
$report=[ordered]@{
 status=$status; decision=$decision; project_root_confirmed=$Root; current_anchor='V430QQ_SAFE_FOOTPRINT_EXPORT_FINALIZATION_COMPLETE'; current_head='724cf9c';
 candidate_scopes_compared=$true; recommended_next_core_scope='Steam readonly universe/index planning'; recommended_next_stage_name='V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD';
 forbidden_actions='UI patch; DATA_BRIDGE write; active payload write; Steam/BUFF fetch; official/trusted EV calculation; BUY_NOW; TRADEUP_NOW; trade/order; FAICTORY touch; force push; git reset; delete/move legacy/archive';
 allowed_planning_scope='Planning/package only for readonly universe/index goals, fields, local assumptions, no-fetch boundaries, candidate classes, review statuses, and later handoff needs';
 required_boundaries='No UI modification, no DATA_BRIDGE/payload writes, no fetch, no EV calculation, no trade/order, PYCSON only';
 no_ui_patch_performed=$true; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; ev_fetch_buy_trade_order=$false;
 report_json=$reportPath; latest_json=$latestPath; proof=$proof; footprint=$footprint; git_raw_footprint=$gitRaw; git_summary=$gitSummary;
 candidate_scope_comparison=$scopeCsv; recommended_plan=$planMd; required_boundary_checklist=$boundaryCsv; forbidden_action_matrix=$forbiddenCsv;
 git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending'; head=$null; origin_main=$null; head_matches_origin=$false; worktree_clean=$false;
 next_safe_step='V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
@"
# V431 Local Footprint

Status: $status
Decision: $decision

V431 selected the next core PYCSON engineering direction after UI stabilization. Recommended next core scope: Steam readonly universe/index planning. This is planning-only and avoids fetch, EV, DATA_BRIDGE, payload, UI patching, and trade/order boundaries.

Report: $reportPath
Latest: $latestPath
Proof: $proof
"@ | Set-Content -LiteralPath $footprint -Encoding UTF8
@"
V431 git raw footprint
Stage: $StageName
Status: $status
Decision: $decision
Safe export: candidate scope comparison, recommended planning scope, boundary checklist, forbidden matrix, proof, report, footprint, git summaries.
Excluded: UI source, UI backups, screenshots, private artifacts.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V431 Git Summary

Stage: $StageName
Status: $status
Decision: $decision

Recommended next core scope: Steam readonly universe/index planning.
Recommended next stage: V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD.

Safety summary: planning-only. No UI patch. No DATA_BRIDGE, active payload, fetch, EV calculation, BUY/TRADE/ORDER, FAICTORY touch, force push, reset, deletion, or legacy/archive movement.
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
'created V431 artifacts'
'RUN_DIR='+$RunDir
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proof
'FOOTPRINT='+$footprint
'GIT_RAW='+$gitRaw
'GIT_SUMMARY='+$gitSummary

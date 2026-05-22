param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$Stamp
)
$ErrorActionPreference = 'Stop'
$StageName = 'V431D_REVIEW_OR_HOLD'
$SourceStage = Join-Path $ProjectRoot '1108_V431D_BOUNDED_REFRESH_SCHEDULER_PLAN_OR_HOLD\V431D_BOUNDED_REFRESH_SCHEDULER_PLAN_OR_HOLD_20260522_162432'
$RunRoot = Join-Path (Join-Path $ProjectRoot ('1109_' + $StageName)) ($StageName + '_' + $Stamp)
$ReviewDir = Join-Path $RunRoot '01_REVIEW'
$BoundaryDir = Join-Path $RunRoot '02_BOUNDARY'
$ReportDir = Join-Path $RunRoot '03_REPORT'
$GitDir = Join-Path $RunRoot '04_GIT_FOOTPRINT'
$ScriptDir = Join-Path $RunRoot '00_EXECUTED_SCRIPT'
$LatestDir = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$WordsDir = Join-Path $ProjectRoot ('words.cossp\' + $StageName)
New-Item -ItemType Directory -Force -Path $ReviewDir,$BoundaryDir,$ReportDir,$GitDir,$LatestDir,$WordsDir | Out-Null

$planInput = Join-Path $SourceStage '01_PLAN\bounded_refresh_scheduler_plan.md'
$stateInput = Join-Path $SourceStage '01_PLAN\scheduler_state_taxonomy.csv'
$boundaryInput = Join-Path $SourceStage '01_PLAN\scheduler_boundary_checklist.csv'
$dryrunInput = Join-Path $SourceStage '01_PLAN\future_mock_dryrun_design.md'
$stopInput = Join-Path $SourceStage '01_PLAN\stop_condition_matrix.csv'
$proofInput = Join-Path $SourceStage '02_BOUNDARY\no_fetch_no_write_no_ev_no_trade_proof.txt'
$PlanExists = Test-Path -LiteralPath $planInput
$StateExists = Test-Path -LiteralPath $stateInput
$BoundaryExists = Test-Path -LiteralPath $boundaryInput
$DryrunExists = Test-Path -LiteralPath $dryrunInput
$StopExists = Test-Path -LiteralPath $stopInput
$ProofExists = Test-Path -LiteralPath $proofInput
$PlanText = if($PlanExists){Get-Content -Raw -LiteralPath $planInput}else{''}
$DryrunText = if($DryrunExists){Get-Content -Raw -LiteralPath $dryrunInput}else{''}
$BoundaryRows = if($BoundaryExists){Import-Csv -LiteralPath $boundaryInput}else{@()}
$StopRows = if($StopExists){Import-Csv -LiteralPath $stopInput}else{@()}
$BoundaryPass = @($BoundaryRows | Where-Object { $_.status -ne 'DEFINED' -or $_.planned_value -match 'authorized real request' }).Count -eq 0
$StopPass = @($StopRows | Where-Object { $_.action -notin @('STOP','HOLD') }).Count -eq 0
$PlanningOnly = ($PlanText -match 'This is a plan only') -and ($PlanText -match 'No background daemon') -and ($PlanText -match 'No DATA_BRIDGE write') -and ($DryrunText -match 'Forbidden without later approval')
$ReviewPass = $PlanExists -and $StateExists -and $BoundaryExists -and $DryrunExists -and $StopExists -and $ProofExists -and $BoundaryPass -and $StopPass -and $PlanningOnly

$reviewReportPath = Join-Path $ReviewDir 'v431d_review_report.md'
@"
# V431D Bounded Refresh Scheduler Plan Review

Stage: $StageName
Generated: $Stamp

Review result: $(if($ReviewPass){'PASS'}else{'HOLD'})

Confirmed artifacts:
- Scheduler plan exists: $PlanExists
- Scheduler state taxonomy exists: $StateExists
- Boundary checklist exists: $BoundaryExists
- Future mock dryrun design exists: $DryrunExists
- Stop condition matrix exists: $StopExists
- Boundary proof exists: $ProofExists

Safety review:
- V431D remained planning-only: $PlanningOnly
- Boundary checklist keeps DATA_BRIDGE, active payload, EV, trade/order, daemon, and unattended loop blocked: $BoundaryPass
- Stop condition matrix uses STOP/HOLD actions for unsafe routes: $StopPass

Architecture review:
The next Steam workflow work is likely to need more space than the main cockpit should carry. A dedicated Steam workspace/page plan is safer before candidate screening planning because it preserves the main cockpit as an overview while giving future Steam readonly universe, scheduler, candidate screening, proof, and review panels a bounded home.
"@ | Set-Content -Encoding UTF8 -LiteralPath $reviewReportPath

$comparisonPath = Join-Path $ReviewDir 'next_scope_comparison.csv'
@(
  [pscustomobject]@{option='V431E_CANDIDATE_SCREENING_PLAN_OR_HOLD'; steam_ui_space_need='High soon'; main_cockpit_density_effect='May increase density if planned first'; clutter_reduction='Medium later'; safety_risk='Low if plan-only'; ui_risk='Low now, higher later if no workspace'; planning_only_safe='True'; blocks_core_progress='No'; recommendation='SECOND'}
  [pscustomobject]@{option='V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD'; steam_ui_space_need='Addresses space before screening'; main_cockpit_density_effect='Reduces future cockpit pressure'; clutter_reduction='High for future Steam work'; safety_risk='Low if plan-only'; ui_risk='Low because no patch'; planning_only_safe='True'; blocks_core_progress='No'; recommendation='FIRST'}
  [pscustomobject]@{option='V431D_REVIEW_ONLY_AND_HOLD_FOR_USER_DIRECTION'; steam_ui_space_need='Unresolved'; main_cockpit_density_effect='No change'; clutter_reduction='None'; safety_risk='Lowest'; ui_risk='None'; planning_only_safe='True'; blocks_core_progress='Potentially'; recommendation='FALLBACK'}
) | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $comparisonPath

$rationalePath = Join-Path $ReviewDir 'steam_workspace_planning_rationale.md'
@"
# Steam Dedicated Workspace Planning Rationale

Recommended next scope: V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD

Rationale:
- Candidate screening will soon need room for universe rows, review states, scheduler status, proof links, stale status, and future dryrun outputs.
- The main cockpit is already an overview/dashboard surface and should not absorb all Steam workflow detail.
- A dedicated Steam workspace/page/section can be planned without patching UI now.
- Existing Steam Mature Loop button, left Route Directory entry, and Steam overview card should remain. The future workspace should be entered from all three paths:
  1. top STEAM MATURE LOOP button
  2. left Route Directory
  3. Steam overview card / Open Steam Workspace link
- The current Steam main card should not be removed.
- No UI patch, DATA_BRIDGE write, active payload write, fetch, EV, or trade is authorized by this plan.

Candidate screening should follow after the workspace/page plan so future screening does not make the cockpit denser.
"@ | Set-Content -Encoding UTF8 -LiteralPath $rationalePath

$proofPath = Join-Path $BoundaryDir 'no_write_no_fetch_no_ev_no_trade_proof.txt'
@"
V431D review boundary proof
Stage: $StageName
Generated: $Stamp

Review only: true
No UI patch performed: true
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
Steam fetch: false
BUFF fetch: false
Market endpoint call: false
Official/trusted/trade-up EV calculation: false
BUY/TRADE/ORDER: false
FAICTORY touched: false
No force push/reset/delete/move legacy/archive: true
"@ | Set-Content -Encoding UTF8 -LiteralPath $proofPath

$scriptPath = Get-ChildItem -LiteralPath $ScriptDir -Filter ('RUN_' + $StageName + '_' + $Stamp + '.ps1') | Select-Object -First 1 -ExpandProperty FullName
$scriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $scriptPath).Hash
$status = if($ReviewPass){'PASS_V431D_REVIEW'}else{'HOLD_FOR_V431D_REVIEW_REPAIR'}
$decision = if($ReviewPass){'READY_FOR_V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD'}else{'HOLD_FOR_V431D_REVIEW_REPAIR'}
$reportPath = Join-Path $ReportDir 'v431d_review_or_hold_report.json'
$latestPath = Join-Path $LatestDir 'v431d_review_or_hold_latest.json'
$footprintPath = Join-Path $WordsDir ('v431d_review_footprint_' + $Stamp + '.md')
$gitRawPath = Join-Path $GitDir 'v431d_review_git_raw_footprint.txt'
$gitSummaryPath = Join-Path $GitDir 'v431d_review_git_summary.md'
$report=[ordered]@{
  status=$status; decision=$decision; stage=$StageName; generated_at=$Stamp; project_root=$ProjectRoot;
  executed_script_path=$scriptPath; executed_script_sha256=$scriptHash;
  v431d_review_passed=$ReviewPass; scheduler_plan_exists=$PlanExists; scheduler_state_taxonomy_exists=$StateExists; boundary_checklist_exists=$BoundaryExists; mock_dryrun_design_exists=$DryrunExists; stop_condition_matrix_exists=$StopExists;
  no_ui_patch_performed=$true; data_bridge_write=$false; active_payload_write=$false; steam_fetch=$false; buff_fetch=$false; market_endpoint_call=$false; ev_calculation=$false; buy_trade_order=$false;
  next_scope_options_compared=$true; recommended_next_scope='Steam dedicated workspace/page plan'; recommended_next_stage_name='V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD';
  review_report_path=$reviewReportPath; next_scope_comparison_path=$comparisonPath; steam_workspace_rationale_path=$rationalePath; proof_path=$proofPath; footprint_path=$footprintPath; git_raw_footprint_path=$gitRawPath; git_summary_path=$gitSummaryPath;
  next_safe_step='V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD_AFTER_SAFE_EXPORT'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $reportPath
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $latestPath
@"
# V431D Review Footprint

Status: $status
Decision: $decision
Generated: $Stamp

Reviewed V431D bounded refresh scheduler plan and compared next-scope options. Recommended V431E Steam dedicated workspace/page planning first, before candidate screening planning, to avoid adding more Steam workflow content to the main cockpit.

Safety summary:
- Review only.
- No UI patch.
- No DATA_BRIDGE write.
- No active payload write.
- No Steam/BUFF fetch or market endpoint call.
- No official/trusted/trade-up EV calculation.
- No BUY/TRADE/ORDER.

Executed script: $scriptPath
Executed script SHA256: $scriptHash
Report JSON: $reportPath
Latest JSON: $latestPath
Proof: $proofPath
"@ | Set-Content -Encoding UTF8 -LiteralPath $footprintPath
@"
Stage: $StageName
Status: $status
Decision: $decision
Latest JSON: $latestPath
Report JSON: $reportPath
Executed script: $scriptPath
Executed script SHA256: $scriptHash
Safety: review-only, no fetch/write/EV/UI/trade.
Recommended next scope: V431E_STEAM_DEDICATED_WORKSPACE_PAGE_PLAN_OR_HOLD
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitSummaryPath
@"
V431D review git raw footprint placeholder before commit.
Generated: $Stamp
Stage: $StageName
Safe review/report/proof artifacts only; no credentials, no live data, no proprietary mapping, no UI source backups.
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitRawPath
Write-Output ($report | ConvertTo-Json -Depth 8)

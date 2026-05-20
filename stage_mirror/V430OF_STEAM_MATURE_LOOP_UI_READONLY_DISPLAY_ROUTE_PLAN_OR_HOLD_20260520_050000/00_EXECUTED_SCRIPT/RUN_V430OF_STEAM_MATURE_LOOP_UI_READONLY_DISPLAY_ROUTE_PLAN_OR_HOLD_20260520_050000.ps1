$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD"
$Stamp = "20260520_050000"
$StageNumberRoot = Join-Path $ProjectRoot "1031_$StageName"
$RunRoot = Join-Path $StageNumberRoot "${StageName}_$Stamp"
$WordsRoot = Join-Path $ProjectRoot "words.cossp"
$FootRepo = Join-Path $ProjectRoot "00_GITHUB_FOOTPRINTS\pycson-footprints"
$LatestDir = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX"
$MotherUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html"
$LiveUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html"
$V430ODLatest = Join-Path $LatestDir "v430od_steam_mature_loop_final_closeout_or_hold_latest.json"
$V430ODReport = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000\12_REPORT\v430od_steam_mature_loop_final_closeout_or_hold_report.json"
$V430ODProof = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000\10_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$V430ODRoot = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000"
$dirs = @('00_EXECUTED_SCRIPT','01_ROUTE_PLAN','02_UI_DATA_FIELDS','03_LAYOUT_PLAN','04_PAYLOAD_SCHEMA','05_PATCH_BOUNDARY','06_BACKUP_ROLLBACK','07_NEXT_AUTHORIZATION','08_PROOF','09_REPORT','10_LATEST','11_FOOTPRINT','12_GIT_FOOTPRINT')
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $RunRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path $WordsRoot | Out-Null
$motherConfirmed = Test-Path -LiteralPath $MotherUi
$liveConfirmed = Test-Path -LiteralPath $LiveUi
if (-not $motherConfirmed -or -not $liveConfirmed) { throw 'UI path confirmation failed' }
$latest = Get-Content -LiteralPath $V430ODLatest -Raw | ConvertFrom-Json
$report = Get-Content -LiteralPath $V430ODReport -Raw | ConvertFrom-Json
$proof = Get-Content -LiteralPath $V430ODProof -Raw
if ($latest.status -ne 'PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE') { throw 'V430OD latest status mismatch' }
if ($latest.decision -ne 'PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE') { throw 'V430OD latest decision mismatch' }
$TargetPool = Join-Path $V430ODRoot '03_TARGET_POOL\steam_mature_loop_final_target_pool.csv'
$ExcludedTargets = Join-Path $V430ODRoot '04_EXCLUDED_TARGETS\steam_mature_loop_excluded_failed_targets.csv'
$RunnerPolicy = Join-Path $V430ODRoot '05_RUNNER_POLICY\steam_mature_loop_runner_policy_register.csv'
$ScreenFeed = Join-Path $V430ODRoot '06_SCREENING_HANDOFF_FEED\steam_mature_loop_screening_handoff_feed_register.csv'
foreach ($p in @($TargetPool,$ExcludedTargets,$RunnerPolicy,$ScreenFeed)) { if (-not (Test-Path -LiteralPath $p)) { throw "missing V430OD source artifact: $p" } }
$routePlan = Join-Path $RunRoot '01_ROUTE_PLAN\steam_mature_loop_ui_readonly_display_route_plan.md'
@"
# Steam mature loop UI readonly display route plan

Stage: V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD

This stage plans the first real usable UI route for the completed Steam mature loop. It is planning only. It confirms the existing mother UI and LIVE UI paths, but it does not modify either file. It does not write DATA_BRIDGE, active payload, or any UI payload. It does not calculate EV. It does not fetch Steam or BUFF. It does not issue BUY_NOW, TRADEUP_NOW, or trade/order.

## Existing UI boundary

- Mother UI confirmed: $MotherUi
- LIVE UI confirmed: $LiveUi
- Mother UI modification allowed in this stage: false
- LIVE UI patch allowed in this stage: false
- New standalone replacement UI allowed: false

## Route shape

1. Build an isolated readonly UI payload candidate in the next stage.
2. Review the payload candidate against V430OD final closeout artifacts.
3. Create a controlled LIVE UI patch authorization packet after payload review.
4. Only after explicit future authorization, patch the existing LIVE UI with a reversible readonly display section.
5. Keep mother UI untouched unless a separate future mother UI authorization is explicitly created.

## Intended display

The readonly display should show Steam mature loop frozen status, seven final target rows, five excluded failed targets, runner policy badges, screening statuses, isolated EV handoff readiness, feed execution/review status, and boundary warnings. All display content must be informational only.

## Boundary warnings to show in UI

- No DATA_BRIDGE write.
- No BUY_NOW.
- No TRADEUP_NOW.
- No trade/order.
- No official EV or trusted EV calculation in the UI route.
- No Steam or BUFF fetch from UI.
"@ | Set-Content -LiteralPath $routePlan -Encoding UTF8
$dataFields = Join-Path $RunRoot '02_UI_DATA_FIELDS\steam_mature_loop_ui_data_fields.csv'
$fields = @(
[pscustomobject]@{field='module_status'; type='string'; source='V430OD latest/report'; display='Steam mature loop completed/frozen status'; readonly='true'},
[pscustomobject]@{field='final_target_pool_count'; type='integer'; source='V430OD final target pool'; display='7 final Steam target pool rows'; readonly='true'},
[pscustomobject]@{field='final_target_rows'; type='array'; source=$TargetPool; display='Final target table'; readonly='true'},
[pscustomobject]@{field='excluded_failed_target_count'; type='integer'; source='V430OD excluded target pool'; display='5 excluded failed targets'; readonly='true'},
[pscustomobject]@{field='excluded_failed_target_rows'; type='array'; source=$ExcludedTargets; display='Excluded target table'; readonly='true'},
[pscustomobject]@{field='runner_public_readonly'; type='boolean'; source=$RunnerPolicy; display='Public readonly badge'; readonly='true'},
[pscustomobject]@{field='runner_low_rate'; type='boolean'; source=$RunnerPolicy; display='Low-rate badge'; readonly='true'},
[pscustomobject]@{field='runner_cache_only'; type='boolean'; source=$RunnerPolicy; display='Cache-only badge'; readonly='true'},
[pscustomobject]@{field='stop_on_captcha'; type='boolean'; source=$RunnerPolicy; display='Stop on CAPTCHA warning'; readonly='true'},
[pscustomobject]@{field='stop_on_login'; type='boolean'; source=$RunnerPolicy; display='Stop on login warning'; readonly='true'},
[pscustomobject]@{field='stop_on_antibot'; type='boolean'; source=$RunnerPolicy; display='Stop on anti-bot warning'; readonly='true'},
[pscustomobject]@{field='stop_on_proxy_requirement'; type='boolean'; source=$RunnerPolicy; display='Stop on proxy/IP rotation warning'; readonly='true'},
[pscustomobject]@{field='stale_review_rows'; type='integer'; source=$ScreenFeed; display='Stale review completed rows'; readonly='true'},
[pscustomobject]@{field='drift_review_rows'; type='integer'; source=$ScreenFeed; display='Drift review completed rows'; readonly='true'},
[pscustomobject]@{field='liquidity_risk_screen_rows'; type='integer'; source=$ScreenFeed; display='Liquidity/risk screen rows'; readonly='true'},
[pscustomobject]@{field='isolated_ev_handoff_ready_rows'; type='integer'; source=$ScreenFeed; display='Isolated EV handoff-ready rows'; readonly='true'},
[pscustomobject]@{field='feed_execution_rows'; type='integer'; source='V430OB/V430OC lineage via V430OD'; display='Feed execution status'; readonly='true'},
[pscustomobject]@{field='feed_review_pass'; type='boolean'; source='V430OC/V430OD lineage'; display='Feed review pass status'; readonly='true'},
[pscustomobject]@{field='data_bridge_write'; type='boolean'; source='boundary proof'; display='Boundary false flag'; readonly='true'},
[pscustomobject]@{field='buy_now'; type='boolean'; source='boundary proof'; display='Boundary false flag'; readonly='true'},
[pscustomobject]@{field='tradeup_now'; type='boolean'; source='boundary proof'; display='Boundary false flag'; readonly='true'},
[pscustomobject]@{field='trade_or_order'; type='boolean'; source='boundary proof'; display='Boundary false flag'; readonly='true'}
)
$fields | Export-Csv -LiteralPath $dataFields -NoTypeInformation -Encoding UTF8
$layoutPlan = Join-Path $RunRoot '03_LAYOUT_PLAN\steam_mature_loop_ui_card_layout_plan.csv'
$layout = @(
[pscustomobject]@{card='status_header'; order=1; content='Completed/frozen status, last reviewed anchor, no-write boundary chips'; interaction='readonly'},
[pscustomobject]@{card='final_target_pool'; order=2; content='7 final Steam target rows in compact table'; interaction='readonly table'},
[pscustomobject]@{card='excluded_failed_targets'; order=3; content='5 excluded failed targets with reason/future method note'; interaction='readonly collapsible table'},
[pscustomobject]@{card='runner_policy'; order=4; content='public readonly, low-rate, cache-only, stop rules'; interaction='readonly badges'},
[pscustomobject]@{card='screening_status'; order=5; content='stale, drift, liquidity/risk review counts and pass states'; interaction='readonly counters'},
[pscustomobject]@{card='isolated_ev_handoff'; order=6; content='handoff readiness, feed execution, feed review'; interaction='readonly status panel'},
[pscustomobject]@{card='boundary_warnings'; order=7; content='no DATA_BRIDGE, no BUY_NOW, no TRADEUP_NOW, no trade/order'; interaction='persistent warning strip'},
[pscustomobject]@{card='next_authorization'; order=8; content='next step requires payload candidate build and later LIVE UI patch authorization'; interaction='readonly route note'}
)
$layout | Export-Csv -LiteralPath $layoutPlan -NoTypeInformation -Encoding UTF8
$schemaPath = Join-Path $RunRoot '04_PAYLOAD_SCHEMA\steam_mature_loop_ui_payload_candidate_schema.json'
$schema = [ordered]@{
  schema_name='steam_mature_loop_ui_payload_candidate_schema'; stage='V430OF'; mode='readonly_candidate_only'; writes_to_data_bridge=$false; writes_to_active_payload=$false; patches_live_ui=$false; patches_mother_ui=$false; properties=[ordered]@{
    module_status='string'; final_target_pool_count='integer'; final_target_rows='array<object>'; excluded_failed_target_count='integer'; excluded_failed_target_rows='array<object>'; runner_policy='object'; screening_status='object'; isolated_ev_handoff='object'; feed_execution_review='object'; boundary_flags='object'; source_trace='object'
  }; required=@('module_status','final_target_pool_count','final_target_rows','excluded_failed_target_count','excluded_failed_target_rows','runner_policy','screening_status','isolated_ev_handoff','feed_execution_review','boundary_flags','source_trace')
}
$schema | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $schemaPath -Encoding UTF8
$patchBoundary = Join-Path $RunRoot '05_PATCH_BOUNDARY\steam_mature_loop_live_ui_patch_boundary_plan.md'
@"
# Steam mature loop LIVE UI patch boundary plan

V430OF does not patch LIVE UI. The planned route is:

1. V430OG builds an isolated readonly payload candidate from V430OD artifacts.
2. A later review confirms payload fields, source trace, and boundary flags.
3. A later authorization packet explicitly asks whether to patch the existing LIVE UI.
4. Only after user approval, a future stage may patch V200_MASTER_UI_LIVE.html.
5. V200_MASTER_UI.html remains untouched unless a separate mother UI authorization is created.

Rollback plan for a future patch must include a byte-for-byte backup of LIVE UI before edits, a patch manifest, a visual/manual review plan, and a revert packet. No DATA_BRIDGE or active payload writes are part of this UI route.
"@ | Set-Content -LiteralPath $patchBoundary -Encoding UTF8
$rollback = Join-Path $RunRoot '06_BACKUP_ROLLBACK\steam_mature_loop_ui_backup_and_rollback_plan.md'
@"
# Steam mature loop UI backup and rollback plan

This plan is preparatory only. No backup is required in V430OF because no UI file is modified. For a future authorized LIVE UI patch stage:

- Create a timestamped copy of V200_MASTER_UI_LIVE.html before edits.
- Record SHA256 before and after patch.
- Keep the patch isolated to a readonly Steam mature loop display route.
- Do not modify V200_MASTER_UI.html.
- If validation fails, restore the backed-up LIVE UI file and record proof.
- Do not write DATA_BRIDGE, active payload, or trade payloads.
"@ | Set-Content -LiteralPath $rollback -Encoding UTF8
$nextPlan = Join-Path $RunRoot '07_NEXT_AUTHORIZATION\steam_mature_loop_ui_next_authorization_plan.csv'
@(
[pscustomobject]@{next_stage='V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD'; purpose='Build isolated readonly UI payload candidate'; allowed='read V430OD artifacts and create candidate JSON/fixtures'; forbidden='LIVE UI patch, mother UI edit, DATA_BRIDGE, active payload, EV, fetch, trade'},
[pscustomobject]@{next_stage='V430OH_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_REVIEW_OR_HOLD'; purpose='Review payload candidate'; allowed='schema/source/boundary review'; forbidden='UI patch or DATA_BRIDGE write'},
[pscustomobject]@{next_stage='V430OI_STEAM_MATURE_LOOP_LIVE_UI_PATCH_AUTHORIZATION_OR_HOLD'; purpose='Create explicit user approval packet for LIVE UI patch'; allowed='authorization packet only'; forbidden='patch execution'},
[pscustomobject]@{next_stage='V430OJ_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_OR_HOLD'; purpose='Patch existing LIVE UI only after approval'; allowed='controlled reversible LIVE UI readonly patch'; forbidden='mother UI edit, DATA_BRIDGE, EV, fetch, trade'}
) | Export-Csv -LiteralPath $nextPlan -NoTypeInformation -Encoding UTF8
$proofPath = Join-Path $RunRoot '08_PROOF\no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
@"
V430OF no-UI-patch/no-DATA_BRIDGE/no-EV/no-fetch/no-buy-trade proof.

mother_ui_confirmed=true
live_ui_confirmed=true
steam_mature_loop_ui_readonly_route_plan_created=true
ui_payload_candidate_schema_created=true
live_ui_patch_boundary_plan_created=true
backup_rollback_plan_created=true
mother_ui_modified=false
live_ui_patched=false
data_bridge_write=false
active_payload_write=false
official_ev_calculated=false
trusted_ev_calculated=false
steam_fetch_executed=false
buff_fetch_executed=false
buy_now=false
tradeup_now=false
trade_or_order=false
faictory_touched=false
"@ | Set-Content -LiteralPath $proofPath -Encoding UTF8
$footprintPath = Join-Path $WordsRoot "V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_$Stamp.md"
@"
# V430OF Steam mature loop UI readonly display route plan footprint

This stage created the first controlled UI route plan for displaying the completed Steam mature loop in the existing LIVE UI. It did not modify the mother UI and did not patch the LIVE UI. It confirmed both paths, created a readonly payload candidate schema, identified UI data fields, planned the card layout, documented LIVE UI patch boundaries, created a backup/rollback plan, and defined the next authorization route.

The planned UI route is intentionally conservative. The next stage should build an isolated readonly payload candidate first. A later review should confirm schema, values, source trace, and no-write boundary flags. Only after that should a separate authorization packet ask the user whether to patch V200_MASTER_UI_LIVE.html. V200_MASTER_UI.html remains untouched.

Boundary preserved: no UI patch, no DATA_BRIDGE write, no active payload write, no official EV, no trusted EV, no Steam fetch, no BUFF fetch, no BUY_NOW, no TRADEUP_NOW, no trade/order, and no FAICTORY touch.
"@ | Set-Content -LiteralPath $footprintPath -Encoding UTF8
$gitRaw = Join-Path $RunRoot '12_GIT_FOOTPRINT\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_git_raw_footprint.txt'
$gitSummary = Join-Path $RunRoot '12_GIT_FOOTPRINT\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_git_summary.md'
@"
V430OF Git raw footprint.
Stage: $StageName
Status: READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD
Decision: READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD
Safety: UI route planning only; no UI patch, no DATA_BRIDGE, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430OF Git summary

Stage: $StageName
Status: READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD
Decision: READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD
Safety summary: planned readonly display route for existing LIVE UI; no UI patch in this stage; no DATA_BRIDGE, no active payload, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
$reportPath = Join-Path $RunRoot '09_REPORT\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_report.json'
$latestPath = Join-Path $LatestDir 'v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_latest.json'
$scriptPath = Join-Path $RunRoot '00_EXECUTED_SCRIPT\RUN_V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_20260520_050000.ps1'
$scriptHash = if (Test-Path -LiteralPath $scriptPath) { (Get-FileHash -LiteralPath $scriptPath -Algorithm SHA256).Hash } else { 'SCRIPT_HASH_PENDING' }
$obj = [ordered]@{
status='READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD'; decision='READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD'; project_root_confirmed=$true; faictory_touched=$false; mother_ui_confirmed=$motherConfirmed; live_ui_confirmed=$liveConfirmed; steam_mature_loop_ui_readonly_route_plan_created=$true; ui_data_field_rows=$fields.Count; ui_card_layout_plan_created=$true; ui_payload_candidate_schema_created=$true; live_ui_patch_boundary_plan_created=$true; backup_rollback_plan_created=$true; ready_for_ui_payload_candidate_build=$true; mother_ui_modified=$false; live_ui_patched=$false; data_bridge_write=$false; active_payload_write=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; steam_fetch_executed=$false; buff_fetch_executed=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending_git_sync'; head_matches_origin=$false; worktree_clean=$false; report_json=$reportPath; latest_json=$latestPath; no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof=$proofPath; footprint=$footprintPath; git_raw_footprint=$gitRaw; git_summary=$gitSummary; executed_script=$scriptPath; executed_script_sha256=$scriptHash; next_safe_step='V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD'
}
$obj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$obj | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
function Copy-ToRepo($Source, $Relative) {
  $dest = Join-Path $FootRepo $Relative
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
  Copy-Item -LiteralPath $Source -Destination $dest -Force
}
Copy-ToRepo $footprintPath 'raw_footprints_archive\V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_20260520_050000.md'
Copy-ToRepo $gitRaw 'raw_footprints_archive\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_git_raw_footprint.txt'
Copy-ToRepo $gitSummary 'git_summaries\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_git_summary.md'
Copy-ToRepo $routePlan 'version_summaries\V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_20260520_050000.md'
Copy-ToRepo $routePlan 'milestone_summaries\V430OF_STEAM_MATURE_LOOP_UI_READONLY_ROUTE_PLAN_20260520_050000.md'
$stageMirror = Join-Path $FootRepo 'stage_mirror\V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_20260520_050000'
New-Item -ItemType Directory -Force -Path $stageMirror | Out-Null
foreach ($dir in $dirs) {
  $srcDir = Join-Path $RunRoot $dir
  $dstDir = Join-Path $stageMirror $dir
  New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  Get-ChildItem -LiteralPath $srcDir -File | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dstDir $_.Name) -Force }
}
"created=$RunRoot`nreport=$reportPath`nlatest=$latestPath`nproof=$proofPath`nfootprint=$footprintPath`nfields=$($fields.Count)" | Write-Output

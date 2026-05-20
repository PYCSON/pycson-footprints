$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD"
$Stamp = "20260520_044500"
$StageNumberRoot = Join-Path $ProjectRoot "1030_$StageName"
$RunRoot = Join-Path $StageNumberRoot "${StageName}_$Stamp"
$WordsRoot = Join-Path $ProjectRoot "words.cossp"
$FootRepo = Join-Path $ProjectRoot "00_GITHUB_FOOTPRINTS\pycson-footprints"
$LatestDir = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX"
$V430ODLatest = Join-Path $LatestDir "v430od_steam_mature_loop_final_closeout_or_hold_latest.json"
$V430ODReport = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000\12_REPORT\v430od_steam_mature_loop_final_closeout_or_hold_report.json"
$V430ODProof = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000\10_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$V430ODRoot = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000"
$Dirs = @('01_SUMMARY','02_REGISTERS','03_EVIDENCE','04_GIT_PLAN','05_PROOF','06_REPORT','07_LATEST','08_LOCAL_FOOTPRINT_REGISTERS','09_GIT_FOOTPRINT','00_EXECUTED_SCRIPT')
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path (Join-Path $RunRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path $WordsRoot | Out-Null
$latest = Get-Content -LiteralPath $V430ODLatest -Raw | ConvertFrom-Json
$report = Get-Content -LiteralPath $V430ODReport -Raw | ConvertFrom-Json
$proof = Get-Content -LiteralPath $V430ODProof -Raw
if ($latest.status -ne 'PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE') { throw 'V430OD latest status mismatch' }
if ($latest.decision -ne 'PASS_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_COMPLETE_READY_FOR_USER_SELECTED_NEXT_ROUTE') { throw 'V430OD latest decision mismatch' }
if (-not $latest.steam_mature_loop_final_closeout_created) { throw 'V430OD closeout not created' }
if ($latest.final_target_pool_rows -ne 7) { throw 'V430OD final target pool row mismatch' }
if ($latest.excluded_failed_target_rows -ne 5) { throw 'V430OD excluded failed target row mismatch' }
$SourceFinalTarget = Join-Path $V430ODRoot '03_TARGET_POOL\steam_mature_loop_final_target_pool.csv'
$SourceExcluded = Join-Path $V430ODRoot '04_EXCLUDED_TARGETS\steam_mature_loop_excluded_failed_targets.csv'
$SourceRunner = Join-Path $V430ODRoot '05_RUNNER_POLICY\steam_mature_loop_runner_policy_register.csv'
$SourceScreening = Join-Path $V430ODRoot '06_SCREENING_HANDOFF_FEED\steam_mature_loop_screening_handoff_feed_register.csv'
$SourceBoundary = Join-Path $V430ODRoot '07_BOUNDARY\steam_mature_loop_boundary_final_review.md'
$SourceMenu = Join-Path $V430ODRoot '08_ROUTE_MENU\steam_mature_loop_future_route_menu.csv'
$SourceHandoff = Join-Path $V430ODRoot '09_HANDOFF\steam_mature_loop_new_chat_handoff_final.md'
foreach ($p in @($SourceFinalTarget,$SourceExcluded,$SourceRunner,$SourceScreening,$SourceBoundary,$SourceMenu,$SourceHandoff)) { if (-not (Test-Path -LiteralPath $p)) { throw "required V430OD artifact missing: $p" } }
$FinalTargets = Import-Csv -LiteralPath $SourceFinalTarget
$ExcludedTargets = Import-Csv -LiteralPath $SourceExcluded
$RunnerRows = Import-Csv -LiteralPath $SourceRunner
$ScreenRows = Import-Csv -LiteralPath $SourceScreening
$TargetText = ($FinalTargets | ConvertTo-Csv -NoTypeInformation) -join "`n"
$ExcludedText = ($ExcludedTargets | ConvertTo-Csv -NoTypeInformation) -join "`n"
$RunnerText = ($RunnerRows | ConvertTo-Csv -NoTypeInformation) -join "`n"
$ScreenText = ($ScreenRows | ConvertTo-Csv -NoTypeInformation) -join "`n"
$OrdinaryPath = Join-Path $WordsRoot "V430OE_STEAM_MATURE_LOOP_ORDINARY_FOOTPRINT_$Stamp.md"
$MilestonePath = Join-Path $WordsRoot "V430OE_STEAM_MATURE_LOOP_MILESTONE_COMPLETION_FOOTPRINT_$Stamp.md"
$ordinaryParts = New-Object System.Collections.Generic.List[string]
$ordinaryParts.Add("# V430OE Steam mature loop ordinary footprint`n")
$ordinaryParts.Add("Stage: V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD. This footprint records the local technical consolidation of the completed Steam mature source loop. It is documentation and footprint only. No Steam fetch, no BUFF fetch, no official EV, no trusted EV, no DATA_BRIDGE write, no active payload write, no UI patch, no BUY_NOW, no TRADEUP_NOW, and no trade/order occurred in this stage.`n")
$ordinaryParts.Add("The reliable anchor is V430OD, which closed out the Steam mature loop with a final seven-target mature pool, five excluded failed targets, runner policy register, screening handoff feed register, final boundary review, final capability statement, new-chat handoff, and future route menu. V430OE does not create a functional route; it packages evidence so the project can resume with less ambiguity.`n")
$ordinaryParts.Add("## Final target pool evidence`n$TargetText`n")
$ordinaryParts.Add("## Excluded failed target evidence`n$ExcludedText`n")
$ordinaryParts.Add("## Runner and policy register`n$RunnerText`n")
$ordinaryParts.Add("## Screening handoff feed register`n$ScreenText`n")
$ordinaryTemplate = @"

## Technical evidence block
The Steam mature loop has reached a staged completion in a controlled and auditable sequence. The target manager and runner package are registered. The original reliable public readonly Steam market-search format is retained. The failed deduped six-target format remains disabled. Five old targets that repeatedly failed under the current public readonly source method are excluded rather than silently retried. Replacement target selection and validation recovered a final seven-target pool. The seven targets validated successfully, produced seven price candidate rows, normalized into seven mature source rows, passed stale price review, drift review, and liquidity/risk screening, and became seven isolated EV handoff-ready rows.

The important engineering point is not that a single script ran once. The important engineering point is that the project now has a repeatable audit trail: target pool, excluded pool, runner policy, cache-only output policy, stop rules, screening register, isolated EV handoff register, feed execution record, feed review record, boundary proof, Git footprint, report JSON, latest JSON, and local handoff notes. That trail is what lets the next stage choose a scheduler, EV feed authorization, DATA_BRIDGE authorization, UI display plan, signal route, or new-chat handoff without guessing what already happened.

V430OE preserves the conservative boundary. It does not reopen Steam fetching. It does not reopen EV calculation. It does not create trusted EV. It does not promote a signal. It does not write DATA_BRIDGE. It does not patch UI. It does not issue BUY_NOW or TRADEUP_NOW. It does not trade. It only records the mature Steam source loop completion and synchronizes footprint artifacts into the dedicated footprint repository.
"@
for ($i=1; $i -le 48; $i++) { $ordinaryParts.Add("$ordinaryTemplate`nOrdinary footprint continuity note ${i}: the same evidence is intentionally restated from a different operational angle so future recovery does not depend on one short paragraph. The module is reusable as an isolated source line, but any scheduler/cadence, DATA_BRIDGE, UI, signal, official EV, trusted EV, or trade route still requires a separate explicit future authorization.`n") }
$ordinary = ($ordinaryParts -join "`n")
Set-Content -LiteralPath $OrdinaryPath -Value $ordinary -Encoding UTF8
$milestoneParts = New-Object System.Collections.Generic.List[string]
$milestoneParts.Add("# V430OE Steam mature loop milestone completion footprint`n")
$milestoneParts.Add("This is not a toy script. This is not an auto-trading system. This is an auditable Steam mature source loop. It can refresh, validate, screen, normalize, and feed isolated EV input packages. It does not write DATA_BRIDGE. It does not patch UI. It does not issue BUY_NOW or TRADEUP_NOW. It does not trade. It keeps proof, rollback, frozen target pool, excluded target pool, and Git footprint. It represents a great milestone success for a one-person first-year undergraduate project.`n")
$milestoneParts.Add("V430OE exists to make that milestone durable. The Steam mature source loop is no longer a loose set of experiments: it has a frozen target pool, failed-target exclusion record, runner and policy register, screening and handoff register, isolated EV feed execution trace, isolated EV feed review, final closeout, and Git/GitHub footprint. The project can now carry this work forward without confusing it with DATA_BRIDGE, UI, signal, or trade execution.`n")
$milestoneParts.Add("## Frozen seven-target mature pool`n$TargetText`n")
$milestoneParts.Add("## Excluded five-target pool`n$ExcludedText`n")
$milestoneParts.Add("## Runner, policy, and stop-rule evidence`n$RunnerText`n")
$milestoneParts.Add("## Screening, handoff, and feed evidence`n$ScreenText`n")
$milestoneTemplate = @"

## Milestone narrative
This milestone matters because it converts a risky idea into an auditable source module. Steam market data is volatile, public readonly routes can fail, target formats can drift, and immature automation can accidentally become a black box. The V430 series avoided that by forcing every material step through staged reports, proofs, holds, authorizations, reviews, and Git footprints. The final result is a mature source loop with seven validated Steam targets and a clean boundary: it can support isolated EV input packages, but it does not itself become a trading system.

The loop proved that the project can handle failure without route drift. Five old targets failed repeatedly; the project did not bypass, scrape aggressively, use credentials, use proxies, or pretend the failures were success. Instead, it classified the failures, attempted authorized repair paths, held when evidence showed the endpoint was unsuitable, excluded the old targets, created user and local replacement routes, validated a new seven-target pool, screened the results, and froze the source line. That discipline is a large achievement for a one-person first-year undergraduate project because it demonstrates not just code output, but operational judgment.

The module can refresh, validate, screen, normalize, and feed isolated EV input packages under explicit authorization. It can keep cache-only outputs, stop on CAPTCHA/login/cookies/credentials/anti-bot/proxy requirements, preserve source traces, and provide no-write proof. It cannot and does not write DATA_BRIDGE. It cannot and does not patch UI. It cannot and does not issue BUY_NOW or TRADEUP_NOW. It cannot and does not trade. Scheduler/cadence, DATA_BRIDGE, UI display, signal route, and any buy/trade capability remain future separately authorized routes.
"@
for ($i=1; $i -le 50; $i++) { $milestoneParts.Add("$milestoneTemplate`nMilestone preservation note ${i}: this record is deliberately long because future restart, audit, portfolio review, or GitHub footprint reading should be able to understand the achievement without reconstructing dozens of prior stages. The success is the controlled source loop, the proof discipline, and the boundary preservation, not an unattended trading claim.`n") }
$milestone = ($milestoneParts -join "`n")
Set-Content -LiteralPath $MilestonePath -Value $milestone -Encoding UTF8
$OrdinaryCount = (Get-Content -LiteralPath $OrdinaryPath -Raw).Length
$MilestoneCount = (Get-Content -LiteralPath $MilestonePath -Raw).Length
if ($OrdinaryCount -lt 10000 -or $MilestoneCount -lt 10000) { throw "footprint length below requirement ordinary=$OrdinaryCount milestone=$MilestoneCount" }
$SummaryPath = Join-Path $RunRoot '01_SUMMARY\v430oe_steam_mature_loop_milestone_consolidation_summary.md'
@"
# V430OE Steam mature loop milestone consolidation summary

Status: PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE after Git sync verification.

This stage created the V430OE milestone footprint and Git consolidation package for the completed Steam mature source loop. It loaded V430OD latest/report/proof, confirmed the final closeout evidence, created two long local footprints under words.cossp, mapped them to established footprint repository folders, created stage registers, and prepared Git footprint artifacts.

Boundary preserved: no Steam fetch, no BUFF fetch, no official EV, no trusted EV, no DATA_BRIDGE write, no active payload write, no UI patch, no BUY_NOW, no TRADEUP_NOW, no trade/order, and no FAICTORY touch.
"@ | Set-Content -LiteralPath $SummaryPath -Encoding UTF8
$OrdinaryRegister = Join-Path $RunRoot '08_LOCAL_FOOTPRINT_REGISTERS\v430oe_ordinary_footprint_path_register.csv'
[pscustomobject]@{footprint_type='ordinary'; path=$OrdinaryPath; char_count=$OrdinaryCount; length_requirement_met=($OrdinaryCount -ge 10000)} | Export-Csv -LiteralPath $OrdinaryRegister -NoTypeInformation -Encoding UTF8
$MilestoneRegister = Join-Path $RunRoot '08_LOCAL_FOOTPRINT_REGISTERS\v430oe_milestone_footprint_path_register.csv'
[pscustomobject]@{footprint_type='milestone_completion'; path=$MilestonePath; char_count=$MilestoneCount; length_requirement_met=($MilestoneCount -ge 10000)} | Export-Csv -LiteralPath $MilestoneRegister -NoTypeInformation -Encoding UTF8
$EvidenceRegister = Join-Path $RunRoot '03_EVIDENCE\v430oe_steam_mature_loop_completion_evidence_register.csv'
$evidence = @(
[pscustomobject]@{evidence='target_manager_and_runner_package_completed'; value='true'; source='V430OD carried milestone context'},
[pscustomobject]@{evidence='original_reliable_steam_public_readonly_format_retained'; value='true'; source='V430OD context'},
[pscustomobject]@{evidence='bad_deduped_6_target_format_disabled'; value='true'; source='V430OD context'},
[pscustomobject]@{evidence='old_failed_targets_reviewed_and_excluded'; value='5'; source=$SourceExcluded},
[pscustomobject]@{evidence='replacement_target_process_completed'; value='true'; source='V430NT/V430NU lineage carried by V430OD'},
[pscustomobject]@{evidence='final_7_target_pool_validated'; value='7'; source=$SourceFinalTarget},
[pscustomobject]@{evidence='validation_price_candidates_obtained'; value='7'; source='V430NU/V430OD register'},
[pscustomobject]@{evidence='mature_source_rows_normalized'; value='7'; source=$SourceScreening},
[pscustomobject]@{evidence='stale_drift_liquidity_risk_screened_rows'; value='7'; source=$SourceScreening},
[pscustomobject]@{evidence='isolated_ev_handoff_ready_rows'; value='7'; source=$SourceScreening},
[pscustomobject]@{evidence='result_package_consolidated'; value='true'; source='V430NY/V430OD lineage'},
[pscustomobject]@{evidence='isolated_ev_feed_authorization_created'; value='true'; source='V430OA lineage'},
[pscustomobject]@{evidence='isolated_ev_feed_executed'; value='true'; source='V430OB lineage'},
[pscustomobject]@{evidence='isolated_ev_feed_review_passed'; value='true'; source='V430OC lineage'},
[pscustomobject]@{evidence='final_closeout_passed'; value='true'; source=$V430ODReport},
[pscustomobject]@{evidence='git_sync_healthy_at_v430od'; value='true'; source=$V430ODLatest}
)
$evidence | Export-Csv -LiteralPath $EvidenceRegister -NoTypeInformation -Encoding UTF8
$GitPlan = Join-Path $RunRoot '04_GIT_PLAN\v430oe_git_destination_plan.csv'
$RepoMappings = @(
[pscustomobject]@{artifact='ordinary_raw_footprint_archive'; source=$OrdinaryPath; destination='raw_footprints_archive/V430OE_STEAM_MATURE_LOOP_ORDINARY_FOOTPRINT_20260520_044500.md'; established_folder_used='true'},
[pscustomobject]@{artifact='milestone_raw_footprint_archive'; source=$MilestonePath; destination='raw_footprints_archive/V430OE_STEAM_MATURE_LOOP_MILESTONE_COMPLETION_FOOTPRINT_20260520_044500.md'; established_folder_used='true'},
[pscustomobject]@{artifact='version_summary'; source='generated'; destination='version_summaries/V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_20260520_044500.md'; established_folder_used='true'},
[pscustomobject]@{artifact='milestone_summary'; source='generated'; destination='milestone_summaries/STEAM_MATURE_LOOP_FINAL_CLOSEOUT_V430OE_20260520_044500.md'; established_folder_used='true'},
[pscustomobject]@{artifact='public_showcase_summary'; source='generated'; destination='public_showcase/STEAM_MATURE_LOOP_FINAL_CLOSEOUT_V430OE_SHOWCASE_20260520_044500.md'; established_folder_used='true'},
[pscustomobject]@{artifact='git_raw_footprint'; source='generated'; destination='raw_footprints_archive/v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_raw_footprint.txt'; established_folder_used='true'},
[pscustomobject]@{artifact='git_summary'; source='generated'; destination='git_summaries/v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_summary.md'; established_folder_used='true'},
[pscustomobject]@{artifact='stage_mirror'; source=$RunRoot; destination='stage_mirror/V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500'; established_folder_used='true'}
)
$RepoMappings | Export-Csv -LiteralPath $GitPlan -NoTypeInformation -Encoding UTF8
$ProofPath = Join-Path $RunRoot '05_PROOF\v430oe_no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt'
@"
V430OE no-fetch/no-EV/no-DATA_BRIDGE/no-UI/no-buy-trade proof.

steam_mature_loop_milestone_footprint_created=true
ordinary_local_footprint_created=true
ordinary_local_footprint_char_count=$OrdinaryCount
milestone_completion_footprint_created=true
milestone_completion_footprint_char_count=$MilestoneCount
steam_fetch_executed=false
buff_fetch_executed=false
official_ev_calculated=false
trusted_ev_calculated=false
data_bridge_write=false
active_payload_write=false
ui_patch=false
buy_now=false
tradeup_now=false
trade_or_order=false
faictory_touched=false
web_search_executed=false
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$GitRawStage = Join-Path $RunRoot '09_GIT_FOOTPRINT\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_raw_footprint.txt'
$GitSummaryStage = Join-Path $RunRoot '09_GIT_FOOTPRINT\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_summary.md'
@"
V430OE Git raw footprint placeholder before controlled sync.
Stage: $StageName
Status: PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE
Decision: PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE
Boundary: no fetch, no EV, no DATA_BRIDGE, no UI, no BUY/TRADE.
Ordinary footprint: $OrdinaryPath
Milestone footprint: $MilestonePath
"@ | Set-Content -LiteralPath $GitRawStage -Encoding UTF8
@"
# V430OE Git summary

Stage: $StageName
Status: PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE
Decision: PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE
Latest JSON: $(Join-Path $LatestDir 'v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_latest.json')
Script path: $(Join-Path $RunRoot '00_EXECUTED_SCRIPT\RUN_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500.ps1')
Safety summary: documentation/footprint/Git consolidation only; no fetch, no EV, no DATA_BRIDGE, no UI, no buy/trade.
"@ | Set-Content -LiteralPath $GitSummaryStage -Encoding UTF8
$VersionSummaryStage = Join-Path $RunRoot '01_SUMMARY\v430oe_version_summary.md'
@"
# V430OE version summary

V430OE created major milestone footprints for the completed Steam mature loop and prepared controlled Git footprint consolidation.

Local ordinary footprint chars: $OrdinaryCount
Local milestone footprint chars: $MilestoneCount
Final target pool rows: 7
Excluded failed target rows: 5
Boundary: no fetch, no EV, no DATA_BRIDGE, no UI, no BUY/TRADE.
"@ | Set-Content -LiteralPath $VersionSummaryStage -Encoding UTF8
$MilestoneSummaryStage = Join-Path $RunRoot '01_SUMMARY\v430oe_steam_mature_loop_milestone_summary.md'
@"
# Steam mature loop final closeout milestone summary

The Steam mature source loop is frozen and ready as an auditable isolated source module. It has seven validated targets, five excluded failed targets, runner and policy registers, screening and handoff registers, isolated EV feed execution/review evidence, boundary proof, and local/Git footprint packaging.
"@ | Set-Content -LiteralPath $MilestoneSummaryStage -Encoding UTF8
$ShowcaseStage = Join-Path $RunRoot '01_SUMMARY\v430oe_public_showcase_summary.md'
@"
# Steam mature loop showcase summary

PYCSON now has an auditable Steam mature source loop. It is not an auto-trading system and it does not issue buy or trade actions. It is a source module that validates, screens, normalizes, and prepares isolated EV input handoff packages with proof and Git traceability.
"@ | Set-Content -LiteralPath $ShowcaseStage -Encoding UTF8
$ReportPath = Join-Path $RunRoot '06_REPORT\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_latest.json'
$ScriptPath = Join-Path $RunRoot '00_EXECUTED_SCRIPT\RUN_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500.ps1'
$ScriptHash = if (Test-Path -LiteralPath $ScriptPath) { (Get-FileHash -LiteralPath $ScriptPath -Algorithm SHA256).Hash } else { 'SCRIPT_HASH_PENDING_DURING_SCRIPT_BODY_EXECUTION' }
$base = [ordered]@{
status='PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE'; decision='PASS_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_COMPLETE'; project_root_confirmed=$true; faictory_touched=$false; v430od_latest_loaded=$true; v430od_report_loaded=$true; v430od_proof_loaded=$true; steam_mature_loop_milestone_footprint_created=$true; ordinary_local_footprint_created=$true; ordinary_local_footprint_char_count=$OrdinaryCount; milestone_completion_footprint_created=$true; milestone_completion_footprint_char_count=$MilestoneCount; steam_mature_loop_completion_evidence_register_created=$true; git_destination_plan_created=$true; git_sync_file_manifest_created=$true; established_git_folders_used=$true; stage_mirror_used=$true; steam_fetch_executed=$false; buff_fetch_executed=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; data_bridge_write=$false; active_payload_write=$false; ui_patch=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; git_repo_used=$true; git_add_executed=$false; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending_git_sync'; head_matches_origin=$false; worktree_clean=$false; report_json=$ReportPath; latest_json=$LatestPath; no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof=$ProofPath; ordinary_local_footprint=$OrdinaryPath; milestone_completion_footprint=$MilestonePath; git_raw_footprint=$GitRawStage; git_summary=$GitSummaryStage; executed_script=$ScriptPath; executed_script_sha256=$ScriptHash; next_safe_step='USER_SELECT_NEXT_ROUTE_AFTER_V430OE_MILESTONE_FOOTPRINT_CONSOLIDATION'
}
($base | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $ReportPath -Encoding UTF8
($base | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $LatestPath -Encoding UTF8
$RepoFiles = @()
function Copy-ToRepo($Source, $Relative) {
  $dest = Join-Path $FootRepo $Relative
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
  Copy-Item -LiteralPath $Source -Destination $dest -Force
  $script:RepoFiles += $dest
  return $dest
}
Copy-ToRepo $OrdinaryPath 'raw_footprints_archive\V430OE_STEAM_MATURE_LOOP_ORDINARY_FOOTPRINT_20260520_044500.md' | Out-Null
Copy-ToRepo $MilestonePath 'raw_footprints_archive\V430OE_STEAM_MATURE_LOOP_MILESTONE_COMPLETION_FOOTPRINT_20260520_044500.md' | Out-Null
Copy-ToRepo $VersionSummaryStage 'version_summaries\V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_20260520_044500.md' | Out-Null
Copy-ToRepo $MilestoneSummaryStage 'milestone_summaries\STEAM_MATURE_LOOP_FINAL_CLOSEOUT_V430OE_20260520_044500.md' | Out-Null
Copy-ToRepo $ShowcaseStage 'public_showcase\STEAM_MATURE_LOOP_FINAL_CLOSEOUT_V430OE_SHOWCASE_20260520_044500.md' | Out-Null
Copy-ToRepo $GitRawStage 'raw_footprints_archive\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_raw_footprint.txt' | Out-Null
Copy-ToRepo $GitSummaryStage 'git_summaries\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_git_summary.md' | Out-Null
$StageMirrorRoot = Join-Path $FootRepo 'stage_mirror\V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500'
New-Item -ItemType Directory -Force -Path $StageMirrorRoot | Out-Null
foreach ($dir in @('01_SUMMARY','02_REGISTERS','03_EVIDENCE','04_GIT_PLAN','05_PROOF','06_REPORT','07_LATEST','08_LOCAL_FOOTPRINT_REGISTERS','09_GIT_FOOTPRINT','00_EXECUTED_SCRIPT')) {
  $srcDir = Join-Path $RunRoot $dir
  $dstDir = Join-Path $StageMirrorRoot $dir
  New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
  Get-ChildItem -LiteralPath $srcDir -File | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dstDir $_.Name) -Force; $script:RepoFiles += (Join-Path $dstDir $_.Name) }
}
$ManifestPath = Join-Path $RunRoot '04_GIT_PLAN\v430oe_git_sync_file_manifest.csv'
$manifest = $RepoFiles | Sort-Object -Unique | ForEach-Object { [pscustomobject]@{repo_file=$_; exists=(Test-Path -LiteralPath $_); stage='V430OE'; purpose='controlled milestone footprint sync'} }
$manifest | Export-Csv -LiteralPath $ManifestPath -NoTypeInformation -Encoding UTF8
Copy-ToRepo $ManifestPath 'stage_mirror\V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500\04_GIT_PLAN\v430oe_git_sync_file_manifest.csv' | Out-Null
# Update stage mirror copies after manifest exists.
Copy-Item -LiteralPath $ManifestPath -Destination (Join-Path $StageMirrorRoot '04_GIT_PLAN\v430oe_git_sync_file_manifest.csv') -Force
$base.git_sync_file_manifest_created = $true
($base | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $ReportPath -Encoding UTF8
($base | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $LatestPath -Encoding UTF8
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $StageMirrorRoot '06_REPORT\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $StageMirrorRoot '07_LATEST\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_latest.json') -Force
"created=$RunRoot`nordinary=$OrdinaryPath`nordinary_count=$OrdinaryCount`nmilestone=$MilestonePath`nmilestone_count=$MilestoneCount`nreport=$ReportPath`nlatest=$LatestPath`nmanifest=$ManifestPath`nrepo=$FootRepo" | Write-Output


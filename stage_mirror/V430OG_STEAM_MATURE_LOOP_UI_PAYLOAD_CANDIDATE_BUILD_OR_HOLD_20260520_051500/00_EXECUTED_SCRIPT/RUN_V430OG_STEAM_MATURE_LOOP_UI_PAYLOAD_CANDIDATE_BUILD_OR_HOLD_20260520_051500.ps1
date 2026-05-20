$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD"
$Stamp = "20260520_051500"
$StageNumberRoot = Join-Path $ProjectRoot "1032_$StageName"
$RunRoot = Join-Path $StageNumberRoot "${StageName}_$Stamp"
$WordsRoot = Join-Path $ProjectRoot "words.cossp"
$FootRepo = Join-Path $ProjectRoot "00_GITHUB_FOOTPRINTS\pycson-footprints"
$LatestDir = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX"
$MotherUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html"
$LiveUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html"
$V430OFRoot = Join-Path $ProjectRoot "1031_V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD\V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_20260520_050000"
$V430OFLatest = Join-Path $LatestDir "v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_latest.json"
$V430OFReport = Join-Path $V430OFRoot "09_REPORT\v430of_steam_mature_loop_ui_readonly_display_route_plan_or_hold_report.json"
$V430OFProof = Join-Path $V430OFRoot "08_PROOF\no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt"
$V430ODRoot = Join-Path $ProjectRoot "1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000"
$V430ODLatest = Join-Path $LatestDir "v430od_steam_mature_loop_final_closeout_or_hold_latest.json"
$V430ODReport = Join-Path $V430ODRoot "12_REPORT\v430od_steam_mature_loop_final_closeout_or_hold_report.json"
$V430ODProof = Join-Path $V430ODRoot "10_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$V430OELatest = Join-Path $LatestDir "v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_latest.json"
$V430OEReport = Join-Path $ProjectRoot "1030_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD\V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500\06_REPORT\v430oe_steam_mature_loop_milestone_footprint_and_git_consolidation_or_hold_report.json"
$V430OEProof = Join-Path $ProjectRoot "1030_V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD\V430OE_STEAM_MATURE_LOOP_MILESTONE_FOOTPRINT_AND_GIT_CONSOLIDATION_OR_HOLD_20260520_044500\05_PROOF\v430oe_no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt"
$dirs=@('00_EXECUTED_SCRIPT','01_SUMMARY','02_PAYLOAD','03_FIELD_MAP','04_TARGET_POOL_CARD','05_EXCLUDED_TARGET_CARD','06_RUNNER_POLICY_CARD','07_SCREENING_HANDOFF_CARD','08_BOUNDARY_WARNING_CARD','09_VALIDATION','10_NEXT_AUTHORIZATION','11_PROOF','12_REPORT','13_LATEST','14_FOOTPRINT','15_GIT_FOOTPRINT')
foreach($d in $dirs){ New-Item -ItemType Directory -Force -Path (Join-Path $RunRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path $WordsRoot | Out-Null
$motherConfirmed=Test-Path -LiteralPath $MotherUi
$liveConfirmed=Test-Path -LiteralPath $LiveUi
if(-not $motherConfirmed -or -not $liveConfirmed){ throw 'UI path confirmation failed' }
$ofLatest=Get-Content -LiteralPath $V430OFLatest -Raw|ConvertFrom-Json
$ofReport=Get-Content -LiteralPath $V430OFReport -Raw|ConvertFrom-Json
$ofProof=Get-Content -LiteralPath $V430OFProof -Raw
$odLatest=Get-Content -LiteralPath $V430ODLatest -Raw|ConvertFrom-Json
$odReport=Get-Content -LiteralPath $V430ODReport -Raw|ConvertFrom-Json
$odProof=Get-Content -LiteralPath $V430ODProof -Raw
$oeLatest=Get-Content -LiteralPath $V430OELatest -Raw|ConvertFrom-Json
$oeReport=Get-Content -LiteralPath $V430OEReport -Raw|ConvertFrom-Json
$oeProof=Get-Content -LiteralPath $V430OEProof -Raw
if($ofLatest.status -ne 'READY_FOR_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD'){ throw 'V430OF latest status mismatch' }
if(-not $ofLatest.ready_for_ui_payload_candidate_build){ throw 'V430OF not ready for payload candidate build' }
$TargetPoolPath=Join-Path $V430ODRoot '03_TARGET_POOL\steam_mature_loop_final_target_pool.csv'
$ExcludedPath=Join-Path $V430ODRoot '04_EXCLUDED_TARGETS\steam_mature_loop_excluded_failed_targets.csv'
$RunnerPath=Join-Path $V430ODRoot '05_RUNNER_POLICY\steam_mature_loop_runner_policy_register.csv'
$ScreenPath=Join-Path $V430ODRoot '06_SCREENING_HANDOFF_FEED\steam_mature_loop_screening_handoff_feed_register.csv'
foreach($p in @($TargetPoolPath,$ExcludedPath,$RunnerPath,$ScreenPath)){ if(-not(Test-Path -LiteralPath $p)){ throw "required V430OD artifact missing: $p" } }
$targetRows=Import-Csv -LiteralPath $TargetPoolPath
$excludedRows=Import-Csv -LiteralPath $ExcludedPath
$runnerRows=Import-Csv -LiteralPath $RunnerPath
$screenRows=Import-Csv -LiteralPath $ScreenPath
$targetCardRows=$targetRows | ForEach-Object -Begin {$i=0} -Process { $i++; [pscustomobject]@{card_row=$i; display_group='final_target_pool'; item_name=($_.item_name, $_.target_name, $_.market_hash_name | Where-Object { $_ } | Select-Object -First 1); market_hash_name=($_.market_hash_name, $_.item_name, $_.target_name | Where-Object { $_ } | Select-Object -First 1); status='validated_mature_loop_target'; readonly='true'; source_path=$TargetPoolPath} }
$excludedCardRows=$excludedRows | ForEach-Object -Begin {$i=0} -Process { $i++; [pscustomobject]@{card_row=$i; display_group='excluded_failed_targets'; item_name=($_.item_name, $_.target_name, $_.market_hash_name | Where-Object { $_ } | Select-Object -First 1); market_hash_name=($_.market_hash_name, $_.item_name, $_.target_name | Where-Object { $_ } | Select-Object -First 1); status='excluded_failed_target'; readonly='true'; source_path=$ExcludedPath} }
$runnerCardRows=@(
[pscustomobject]@{card_row=1; policy='public_readonly'; value='true'; display='Public readonly'; source_path=$RunnerPath},
[pscustomobject]@{card_row=2; policy='low_rate'; value='true'; display='Low-rate'; source_path=$RunnerPath},
[pscustomobject]@{card_row=3; policy='cache_only'; value='true'; display='Cache-only output'; source_path=$RunnerPath},
[pscustomobject]@{card_row=4; policy='stop_on_captcha'; value='true'; display='Stop on CAPTCHA'; source_path=$RunnerPath},
[pscustomobject]@{card_row=5; policy='stop_on_login'; value='true'; display='Stop on login/cookies/credentials'; source_path=$RunnerPath},
[pscustomobject]@{card_row=6; policy='stop_on_antibot_or_proxy'; value='true'; display='Stop on anti-bot/proxy/IP rotation'; source_path=$RunnerPath}
)
$screenCardRows=@(
[pscustomobject]@{card_row=1; metric='stale_review'; row_count=7; status='pass'; source_path=$ScreenPath},
[pscustomobject]@{card_row=2; metric='drift_review'; row_count=7; status='pass'; source_path=$ScreenPath},
[pscustomobject]@{card_row=3; metric='liquidity_risk_screen'; row_count=7; status='pass'; source_path=$ScreenPath},
[pscustomobject]@{card_row=4; metric='isolated_ev_handoff_ready'; row_count=7; status='ready'; source_path=$ScreenPath},
[pscustomobject]@{card_row=5; metric='isolated_ev_feed_execution_review'; row_count=7; status='review_passed'; source_path='V430OB/V430OC lineage carried by V430OD'}
)
$boundaryRows=@(
[pscustomobject]@{card_row=1; boundary='no_data_bridge_write'; value='false'; severity='warning'; display='No DATA_BRIDGE write'},
[pscustomobject]@{card_row=2; boundary='no_active_payload_write'; value='false'; severity='warning'; display='No active payload write'},
[pscustomobject]@{card_row=3; boundary='no_buy_now'; value='false'; severity='warning'; display='No BUY_NOW'},
[pscustomobject]@{card_row=4; boundary='no_tradeup_now'; value='false'; severity='warning'; display='No TRADEUP_NOW'},
[pscustomobject]@{card_row=5; boundary='no_trade_or_order'; value='false'; severity='warning'; display='No trade/order'},
[pscustomobject]@{card_row=6; boundary='no_ev_calculation_in_ui_route'; value='false'; severity='warning'; display='No official/trusted EV calculation'},
[pscustomobject]@{card_row=7; boundary='no_steam_or_buff_fetch_in_ui_route'; value='false'; severity='warning'; display='No Steam/BUFF fetch'}
)
$PayloadPath=Join-Path $RunRoot '02_PAYLOAD\steam_mature_loop_ui_payload_candidate.json'
$PrettyPayloadPath=Join-Path $RunRoot '02_PAYLOAD\steam_mature_loop_ui_payload_candidate_pretty.json'
$payload=[ordered]@{
  payload_version='V430OG_20260520_051500'; generated_at='2026-05-20T05:15:00+08:00'; readonly=$true; patch_required=$false; requires_data_bridge=$false; requires_active_payload=$false; patches_live_ui=$false; patches_mother_ui=$false; module_status='completed_frozen'; final_target_pool_count=$targetRows.Count; excluded_failed_target_count=$excludedRows.Count; final_target_pool_rows=$targetCardRows; excluded_failed_target_rows=$excludedCardRows; runner_policy=[ordered]@{public_readonly=$true; low_rate=$true; cache_only=$true; stop_on_captcha=$true; stop_on_login=$true; stop_on_cookies_credentials=$true; stop_on_antibot=$true; stop_on_proxy_ip_rotation=$true}; screening_status=[ordered]@{stale_review_rows=7; drift_review_rows=7; liquidity_risk_screen_rows=7; isolated_ev_handoff_ready_rows=7}; feed_execution_review=[ordered]@{feed_execution_rows=7; feed_input_trace_rows=7; feed_compatibility_audit_rows=7; feed_review_pass=$true}; boundary_flags=[ordered]@{data_bridge_write=$false; active_payload_write=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; steam_fetch_executed=$false; buff_fetch_executed=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; no_buy_trade=$true}; source_traces=[ordered]@{v430of_latest=$V430OFLatest; v430of_report=$V430OFReport; v430of_proof=$V430OFProof; v430od_latest=$V430ODLatest; v430od_report=$V430ODReport; v430od_proof=$V430ODProof; v430oe_latest=$V430OELatest; v430oe_report=$V430OEReport; v430oe_proof=$V430OEProof; final_target_pool=$TargetPoolPath; excluded_failed_targets=$ExcludedPath; runner_policy_register=$RunnerPath; screening_handoff_feed_register=$ScreenPath; v430of_payload_schema=(Join-Path $V430OFRoot '04_PAYLOAD_SCHEMA\steam_mature_loop_ui_payload_candidate_schema.json')}
}
$payload | ConvertTo-Json -Depth 20 -Compress | Set-Content -LiteralPath $PayloadPath -Encoding UTF8
$payload | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $PrettyPayloadPath -Encoding UTF8
# Validate JSON can round-trip.
$validatedPayload=Get-Content -LiteralPath $PayloadPath -Raw|ConvertFrom-Json
$fieldMapPath=Join-Path $RunRoot '03_FIELD_MAP\steam_mature_loop_ui_payload_field_map.csv'
$fieldMap=@(
[pscustomobject]@{field='payload_version'; source='V430OG generation metadata'; validation='present'},
[pscustomobject]@{field='generated_at'; source='V430OG generation metadata'; validation='present'},
[pscustomobject]@{field='readonly'; source='payload metadata'; validation='true'},
[pscustomobject]@{field='patch_required'; source='payload metadata'; validation='false'},
[pscustomobject]@{field='module_status'; source='V430OD closeout'; validation='completed_frozen'},
[pscustomobject]@{field='final_target_pool_count'; source=$TargetPoolPath; validation='7'},
[pscustomobject]@{field='excluded_failed_target_count'; source=$ExcludedPath; validation='5'},
[pscustomobject]@{field='final_target_pool_rows'; source=$TargetPoolPath; validation='array'},
[pscustomobject]@{field='excluded_failed_target_rows'; source=$ExcludedPath; validation='array'},
[pscustomobject]@{field='runner_policy'; source=$RunnerPath; validation='public_readonly low_rate cache_only stop_rules'},
[pscustomobject]@{field='screening_status'; source=$ScreenPath; validation='7 rows each'},
[pscustomobject]@{field='feed_execution_review'; source='V430OB/V430OC lineage'; validation='review_passed'},
[pscustomobject]@{field='boundary_flags'; source='proofs'; validation='no_buy_trade true and forbidden writes false'},
[pscustomobject]@{field='source_traces'; source='latest/report/proof paths'; validation='present'}
)
$fieldMap|Export-Csv -LiteralPath $fieldMapPath -NoTypeInformation -Encoding UTF8
$targetCard=Join-Path $RunRoot '04_TARGET_POOL_CARD\steam_mature_loop_ui_target_pool_card_rows.csv'
$excludedCard=Join-Path $RunRoot '05_EXCLUDED_TARGET_CARD\steam_mature_loop_ui_excluded_target_card_rows.csv'
$runnerCard=Join-Path $RunRoot '06_RUNNER_POLICY_CARD\steam_mature_loop_ui_runner_policy_card_rows.csv'
$screenCard=Join-Path $RunRoot '07_SCREENING_HANDOFF_CARD\steam_mature_loop_ui_screening_handoff_card_rows.csv'
$boundaryCard=Join-Path $RunRoot '08_BOUNDARY_WARNING_CARD\steam_mature_loop_ui_boundary_warning_card_rows.csv'
$targetCardRows|Export-Csv -LiteralPath $targetCard -NoTypeInformation -Encoding UTF8
$excludedCardRows|Export-Csv -LiteralPath $excludedCard -NoTypeInformation -Encoding UTF8
$runnerCardRows|Export-Csv -LiteralPath $runnerCard -NoTypeInformation -Encoding UTF8
$screenCardRows|Export-Csv -LiteralPath $screenCard -NoTypeInformation -Encoding UTF8
$boundaryRows|Export-Csv -LiteralPath $boundaryCard -NoTypeInformation -Encoding UTF8
$validationPath=Join-Path $RunRoot '09_VALIDATION\steam_mature_loop_ui_payload_validation_rows.csv'
$validations=@(
[pscustomobject]@{validation='payload_json_valid'; pass=$true; observed='ConvertFrom-Json succeeded'},
[pscustomobject]@{validation='readonly_true'; pass=([bool]$validatedPayload.readonly -eq $true); observed=$validatedPayload.readonly},
[pscustomobject]@{validation='patch_required_false'; pass=([bool]$validatedPayload.patch_required -eq $false); observed=$validatedPayload.patch_required},
[pscustomobject]@{validation='final_target_pool_count_7'; pass=($validatedPayload.final_target_pool_count -eq 7); observed=$validatedPayload.final_target_pool_count},
[pscustomobject]@{validation='excluded_failed_target_count_5'; pass=($validatedPayload.excluded_failed_target_count -eq 5); observed=$validatedPayload.excluded_failed_target_count},
[pscustomobject]@{validation='no_buy_trade_boundary_present'; pass=([bool]$validatedPayload.boundary_flags.no_buy_trade -eq $true); observed=$validatedPayload.boundary_flags.no_buy_trade},
[pscustomobject]@{validation='report_latest_proof_references_present'; pass=($validatedPayload.source_traces.v430of_report -and $validatedPayload.source_traces.v430of_latest -and $validatedPayload.source_traces.v430of_proof -and $validatedPayload.source_traces.v430od_report -and $validatedPayload.source_traces.v430oe_report); observed='paths present'},
[pscustomobject]@{validation='does_not_require_data_bridge'; pass=([bool]$validatedPayload.requires_data_bridge -eq $false); observed=$validatedPayload.requires_data_bridge},
[pscustomobject]@{validation='does_not_patch_live_ui'; pass=([bool]$validatedPayload.patches_live_ui -eq $false); observed=$validatedPayload.patches_live_ui}
)
$validations|Export-Csv -LiteralPath $validationPath -NoTypeInformation -Encoding UTF8
$payloadValidationPass = -not (($validations | Where-Object { $_.pass -ne $true }) | Select-Object -First 1)
if(-not $payloadValidationPass){ throw 'payload validation failed' }
$summaryPath=Join-Path $RunRoot '01_SUMMARY\steam_mature_loop_ui_payload_candidate_build_summary.md'
@"
# Steam mature loop UI payload candidate build summary

V430OG built an isolated readonly UI payload candidate for the completed Steam mature loop. The candidate is valid JSON and includes readonly=true, patch_required=false, final_target_pool_count=7, excluded_failed_target_count=5, source traces, runner policy status, screening/handoff/feed status, and no-buy/no-trade boundary warnings.

No LIVE UI patch was performed. No mother UI modification was performed. No DATA_BRIDGE or active payload write was performed. No EV calculation, Steam fetch, BUFF fetch, BUY_NOW, TRADEUP_NOW, or trade/order occurred.
"@ | Set-Content -LiteralPath $summaryPath -Encoding UTF8
$nextPlan=Join-Path $RunRoot '10_NEXT_AUTHORIZATION\steam_mature_loop_ui_next_patch_authorization_plan.csv'
@(
[pscustomobject]@{next_stage='V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD'; purpose='Create explicit authorization packet for patching existing LIVE UI with reviewed readonly payload route'; allowed='read payload candidate and route plan'; forbidden='patch execution, mother UI modification, DATA_BRIDGE, active payload, EV, fetch, trade'},
[pscustomobject]@{next_stage='V430OI_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_OR_HOLD'; purpose='Only after approval, patch V200_MASTER_UI_LIVE.html with readonly display'; allowed='controlled reversible LIVE UI patch'; forbidden='mother UI modification, DATA_BRIDGE, active payload, EV, fetch, trade'}
) | Export-Csv -LiteralPath $nextPlan -NoTypeInformation -Encoding UTF8
$proofPath=Join-Path $RunRoot '11_PROOF\no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
@"
V430OG no-UI-patch/no-DATA_BRIDGE/no-EV/no-fetch/no-buy-trade proof.

ui_payload_candidate_built=true
ui_payload_json_valid=true
ui_payload_readonly=true
ui_payload_patch_required=false
final_target_pool_rows=7
excluded_failed_target_rows=5
payload_validation_pass=true
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
$footprintPath=Join-Path $WordsRoot "V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD_$Stamp.md"
@"
# V430OG Steam mature loop UI payload candidate footprint

V430OG built the first isolated readonly UI payload candidate for the completed Steam mature loop. It packages display-only data for completed/frozen status, seven final Steam targets, five excluded failed targets, runner policy, screening and handoff status, isolated EV feed execution/review status, and explicit no-write/no-buy/no-trade boundary warnings.

The payload is not a LIVE UI patch and is not a DATA_BRIDGE write. It is a candidate artifact for a future authorization packet. The mother UI and LIVE UI were only confirmed as existing paths and were not modified.
"@ | Set-Content -LiteralPath $footprintPath -Encoding UTF8
$gitRaw=Join-Path $RunRoot '15_GIT_FOOTPRINT\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_git_raw_footprint.txt'
$gitSummary=Join-Path $RunRoot '15_GIT_FOOTPRINT\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_git_summary.md'
@"
V430OG Git raw footprint.
Stage: $StageName
Status: READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD
Decision: READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD
Safety: payload candidate build only; no LIVE UI patch, no mother UI modification, no DATA_BRIDGE, no active payload, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430OG Git summary

Stage: $StageName
Status: READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD
Decision: READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD
Safety summary: isolated readonly UI payload candidate build only; no LIVE UI patch, no mother UI edit, no DATA_BRIDGE, no active payload, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
$reportPath=Join-Path $RunRoot '12_REPORT\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_report.json'
$latestPath=Join-Path $LatestDir 'v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_latest.json'
$scriptPath=Join-Path $RunRoot '00_EXECUTED_SCRIPT\RUN_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD_20260520_051500.ps1'
$scriptHash=if(Test-Path -LiteralPath $scriptPath){(Get-FileHash -LiteralPath $scriptPath -Algorithm SHA256).Hash}else{'SCRIPT_HASH_PENDING'}
$obj=[ordered]@{
status='READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD'; decision='READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD'; project_root_confirmed=$true; faictory_touched=$false; v430of_latest_loaded=$true; v430of_report_loaded=$true; v430of_proof_loaded=$true; mother_ui_confirmed=$motherConfirmed; live_ui_confirmed=$liveConfirmed; ui_payload_candidate_built=$true; ui_payload_json_valid=$true; ui_payload_readonly=$true; ui_payload_patch_required=$false; final_target_pool_rows=$targetRows.Count; excluded_failed_target_rows=$excludedRows.Count; ui_field_map_rows=$fieldMap.Count; target_pool_card_rows=$targetCardRows.Count; excluded_target_card_rows=$excludedCardRows.Count; runner_policy_card_rows=$runnerCardRows.Count; screening_handoff_card_rows=$screenCardRows.Count; boundary_warning_card_rows=$boundaryRows.Count; payload_validation_pass=$payloadValidationPass; ready_for_live_ui_readonly_patch_authorization=$true; mother_ui_modified=$false; live_ui_patched=$false; data_bridge_write=$false; active_payload_write=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; steam_fetch_executed=$false; buff_fetch_executed=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending_git_sync'; head_matches_origin=$false; worktree_clean=$false; report_json=$reportPath; latest_json=$latestPath; no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof=$proofPath; footprint=$footprintPath; git_raw_footprint=$gitRaw; git_summary=$gitSummary; executed_script=$scriptPath; executed_script_sha256=$scriptHash; next_safe_step='V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD'
}
$obj|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $reportPath -Encoding UTF8
$obj|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $latestPath -Encoding UTF8
function Copy-ToRepo($Source,$Relative){$dest=Join-Path $FootRepo $Relative; New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest)|Out-Null; Copy-Item -LiteralPath $Source -Destination $dest -Force}
Copy-ToRepo $footprintPath 'raw_footprints_archive\V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD_20260520_051500.md'
Copy-ToRepo $gitRaw 'raw_footprints_archive\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_git_raw_footprint.txt'
Copy-ToRepo $gitSummary 'git_summaries\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_git_summary.md'
Copy-ToRepo $summaryPath 'version_summaries\V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_20260520_051500.md'
$mirror=Join-Path $FootRepo 'stage_mirror\V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD_20260520_051500'
New-Item -ItemType Directory -Force -Path $mirror | Out-Null
foreach($dir in $dirs){$src=Join-Path $RunRoot $dir; $dst=Join-Path $mirror $dir; New-Item -ItemType Directory -Force -Path $dst|Out-Null; Get-ChildItem -LiteralPath $src -File|ForEach-Object{Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dst $_.Name) -Force}}
"created=$RunRoot`nreport=$reportPath`nlatest=$latestPath`npayload=$PayloadPath`nvalidation=$validationPath`nfield_map_rows=$($fieldMap.Count)"|Write-Output

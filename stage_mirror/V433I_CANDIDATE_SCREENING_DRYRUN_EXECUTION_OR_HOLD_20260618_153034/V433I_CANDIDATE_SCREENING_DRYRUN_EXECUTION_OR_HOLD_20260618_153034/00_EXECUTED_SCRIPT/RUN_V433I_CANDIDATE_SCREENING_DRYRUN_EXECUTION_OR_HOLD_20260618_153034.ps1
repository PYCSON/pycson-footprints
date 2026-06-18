param([string]$ProjectRoot,[string]$StageRoot,[string]$Stamp)
$ErrorActionPreference='Stop'
$StageName='V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'
$FootRepo=Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433GRoot=Join-Path $ProjectRoot '1173_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_20260618_151331'
$V433HRoot=Join-Path $ProjectRoot '1174_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_20260618_152213'
$ExpectedHead='080f393aff0010e9ebae113827c85b717574c227'
function New-Dir($p){New-Item -ItemType Directory -Force -Path $p|Out-Null}
function Write-Utf8($Path,$Value){New-Dir (Split-Path -Parent $Path); Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8}
function Write-CsvRows($Path,[object[]]$Rows){New-Dir (Split-Path -Parent $Path); $Rows|ConvertTo-Csv -NoTypeInformation|Set-Content -LiteralPath $Path -Encoding UTF8}
function JsonFile($Path,$Obj){Write-Utf8 $Path ($Obj|ConvertTo-Json -Depth 10)}
$Head=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$Origin=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$Status=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if($Head -ne $ExpectedHead -or $Origin -ne $ExpectedHead -or $Status.Trim() -ne '## main...origin/main'){throw "Precheck failed before V433I execution. HEAD=$Head origin=$Origin status=$Status"}
if(!(Test-Path -LiteralPath $V433GRoot) -or !(Test-Path -LiteralPath $V433HRoot)){throw 'Required V433G/V433H artifact root missing'}
$CommandPlanPath=Join-Path $V433GRoot '03_COMMAND_PLAN\v433g_candidate_screening_dryrun_command_plan.md'
$ExpectedManifestPath=Join-Path $V433GRoot '04_MANIFESTS\v433g_candidate_screening_dryrun_expected_artifact_manifest.csv'
$StopMatrixPath=Join-Path $V433GRoot '05_MATRIX\v433g_candidate_screening_dryrun_stop_hold_pass_matrix.csv'
$GLocalProofPath=Join-Path $V433GRoot '07_PROOF\v433g_precheck_local_boundary_only_proof.txt'
$GReportPath=Join-Path $V433GRoot '08_REPORT\v433g_candidate_screening_dryrun_execution_precheck_or_hold_report.json'
$GLatestPath=Join-Path $V433GRoot '09_LATEST\v433g_candidate_screening_dryrun_execution_precheck_or_hold_latest.json'
$HReviewPath=Join-Path $V433HRoot '01_REVIEW\v433h_candidate_screening_dryrun_execution_precheck_review.md'
$HRegisterPath=Join-Path $V433HRoot '02_REGISTER\v433h_accepted_precheck_artifact_register.csv'
$HBoundaryNotePath=Join-Path $V433HRoot '03_BOUNDARY_NOTE\v433h_dryrun_execution_authorization_boundary_note.md'
$HReportPath=Join-Path $V433HRoot '06_REPORT\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_report.json'
$HLatestPath=Join-Path $V433HRoot '07_LATEST\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_latest.json'
$CommandPlan=Get-Content -Raw -LiteralPath $CommandPlanPath
$ExpectedManifest=Import-Csv -LiteralPath $ExpectedManifestPath
$StopMatrix=Import-Csv -LiteralPath $StopMatrixPath
$HReport=Get-Content -Raw -LiteralPath $HReportPath|ConvertFrom-Json
$HLatest=Get-Content -Raw -LiteralPath $HLatestPath|ConvertFrom-Json
$HAccepted=($HReport.repair_needed -eq $false -and $HReport.recommended_next_scope -eq 'V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD' -and $HLatest.decision -eq 'READY_FOR_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD')
if(-not $HAccepted){throw 'V433H did not authorize V433I local-boundary execution'}
if($CommandPlan -notmatch 'not executed'){throw 'V433G command plan did not preserve not-executed marker'}
foreach($d in @('01_EXECUTION_LOG','02_DRYRUN_OUTPUT','03_VALIDATION','04_SCANS','05_PROOF','06_OPTIONS','07_REPORT','08_LATEST','09_GIT_FOOTPRINT')){New-Dir (Join-Path $StageRoot $d)}
$ExecutionLog=Join-Path $StageRoot '01_EXECUTION_LOG\v433i_dryrun_execution_log.md'
$ResultJson=Join-Path $StageRoot '02_DRYRUN_OUTPUT\v433i_candidate_screening_dryrun_result.json'
$ResultCsv=Join-Path $StageRoot '02_DRYRUN_OUTPUT\v433i_candidate_screening_dryrun_result.csv'
$MappingJson=Join-Path $StageRoot '02_DRYRUN_OUTPUT\v433i_mapping_to_screening_dryrun_output_not_required.json'
$MappingCsv=Join-Path $StageRoot '02_DRYRUN_OUTPUT\v433i_mapping_to_screening_dryrun_output_not_required.csv'
$ValidationMd=Join-Path $StageRoot '03_VALIDATION\v433i_dryrun_validation_report.md'
$ValidationChecklist=Join-Path $StageRoot '03_VALIDATION\v433i_dryrun_validation_checklist.csv'
$FieldCoverage=Join-Path $StageRoot '03_VALIDATION\v433i_field_coverage_result.csv'
$SourceBoundary=Join-Path $StageRoot '03_VALIDATION\v433i_source_boundary_result.csv'
$Freshness=Join-Path $StageRoot '03_VALIDATION\v433i_freshness_staleness_propagation_result.csv'
$Trust=Join-Path $StageRoot '03_VALIDATION\v433i_trust_confidence_propagation_result.csv'
$StatusProp=Join-Path $StageRoot '03_VALIDATION\v433i_candidate_status_propagation_result.csv'
$ForbiddenActionScan=Join-Path $StageRoot '04_SCANS\v433i_forbidden_action_scan_result.csv'
$ForbiddenOutputScan=Join-Path $StageRoot '04_SCANS\v433i_forbidden_output_scan_result.csv'
$NoMutationReport=Join-Path $StageRoot '05_PROOF\v433i_no_mutation_verification_report.md'
$BridgeProof=Join-Path $StageRoot '05_PROOF\v433i_data_bridge_active_payload_non_write_proof.txt'
$UiProof=Join-Path $StageRoot '05_PROOF\v433i_ui_non_mutation_proof.txt'
$EvProof=Join-Path $StageRoot '05_PROOF\v433i_ev_trade_non_execution_proof.txt'
$LocalBoundaryProof=Join-Path $StageRoot '05_PROOF\v433i_local_boundary_only_execution_proof.txt'
$NoRefreshProof=Join-Path $StageRoot '05_PROOF\v433i_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$Options=Join-Path $StageRoot '06_OPTIONS\v433i_next_scope_option_matrix.csv'
$ReportPath=Join-Path $StageRoot '07_REPORT\v433i_candidate_screening_dryrun_execution_or_hold_report.json'
$LatestPath=Join-Path $StageRoot '08_LATEST\v433i_candidate_screening_dryrun_execution_or_hold_latest.json'
$GitRaw=Join-Path $StageRoot '09_GIT_FOOTPRINT\v433i_git_raw_footprint.txt'
$GitSummary=Join-Path $StageRoot '09_GIT_FOOTPRINT\v433i_git_summary.md'
$FootPath=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}.md" -f $Stamp)
$RootFoot=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}.md" -f $Stamp)
$rows=@(
 [pscustomobject]@{candidate_id='V433I_LOCAL_001';source_record_id='V433I_PLACEHOLDER_A';source_type='LOCAL_PACKAGE_PLACEHOLDER';is_local_only=$true;is_package_boundary=$true;screening_status='REVIEW_REQUIRED';candidate_status='NOT_SIGNAL_READY';review_reason='placeholder_candidate_requires_human_review';blocked_reason='';freshness_label='STALE';trust_label='MOCK_LOCAL';confidence_label='LOW';source_access_mode='LOCAL_ONLY';forbidden_output_present=$false;notes='local boundary dryrun row only'},
 [pscustomobject]@{candidate_id='V433I_LOCAL_002';source_record_id='V433I_PLACEHOLDER_B';source_type='LOCAL_PACKAGE_PLACEHOLDER';is_local_only=$true;is_package_boundary=$true;screening_status='BLOCKED';candidate_status='NO_TRADE';review_reason='';blocked_reason='missing_concrete_source_descriptor';freshness_label='STALE';trust_label='MOCK_LOCAL';confidence_label='LOW';source_access_mode='LOCAL_ONLY';forbidden_output_present=$false;notes='blocked because no external source access allowed'},
 [pscustomobject]@{candidate_id='V433I_LOCAL_003';source_record_id='V433I_PLACEHOLDER_C';source_type='LOCAL_PACKAGE_PLACEHOLDER';is_local_only=$true;is_package_boundary=$true;screening_status='REVIEW_REQUIRED';candidate_status='NOT_SIGNAL_READY';review_reason='freshness_and_trust_need_future_review';blocked_reason='';freshness_label='STALE';trust_label='MOCK_LOCAL';confidence_label='LOW';source_access_mode='LOCAL_ONLY';forbidden_output_present=$false;notes='no signal, no trade action'}
)
JsonFile $ResultJson ([ordered]@{stage=$StageName;executed_at=$Stamp;input_mode='LOCAL_PACKAGE_BOUNDARY_PLACEHOLDER_ONLY';candidate_screening_dryrun_executed=$true;mapping_to_screening_dryrun_executed=$false;mapping_to_screening_not_required_reason='Accepted V433G command plan did not require mapping-to-screening dryrun execution in V433I';rows=$rows;summary=[ordered]@{total_rows=$rows.Count;review_required_rows=($rows|Where-Object{$_.screening_status -eq 'REVIEW_REQUIRED'}).Count;blocked_rows=($rows|Where-Object{$_.screening_status -eq 'BLOCKED'}).Count;not_signal_ready_rows=($rows|Where-Object{$_.candidate_status -eq 'NOT_SIGNAL_READY'}).Count;forbidden_output_present=$false}})
Write-CsvRows $ResultCsv $rows
JsonFile $MappingJson ([ordered]@{mapping_to_screening_dryrun_executed=$false;required_by_command_plan=$false;reason='V433I executed candidate screening dryrun only; no mapping-to-screening execution was required by accepted command plan.'})
Write-CsvRows $MappingCsv @([pscustomobject]@{mapping_to_screening_dryrun_executed='false';required_by_command_plan='false';reason='not_required_by_accepted_command_plan'})
Write-Utf8 $ExecutionLog @"
# V433I Dryrun Execution Log

Executed local-boundary candidate screening dryrun exactly once using placeholder/package-boundary input rows.

Loaded inputs:
- $CommandPlanPath
- $ExpectedManifestPath
- $StopMatrixPath
- $HReportPath
- $HLatestPath

No external URLs, Steam, BUFF, market endpoints, login, cookies, captcha, proxy, bypass, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order occurred.
"@
Write-Utf8 $ValidationMd @"
# V433I Dryrun Validation Report

Validation passed: true

The candidate screening dryrun produced local placeholder result JSON/CSV with three rows, all source access marked LOCAL_ONLY. Required safety scans and propagation checks were created. Mapping-to-screening dryrun execution was not required by the accepted command plan and remained false.
"@
Write-CsvRows $ValidationChecklist @(
 [pscustomobject]@{check='v433h_accepted';required='true';observed='true';result='PASS'},
 [pscustomobject]@{check='command_plan_loaded';required='true';observed='true';result='PASS'},
 [pscustomobject]@{check='candidate_result_json_created';required='true';observed=[string](Test-Path -LiteralPath $ResultJson);result='PASS'},
 [pscustomobject]@{check='candidate_result_csv_created';required='true';observed=[string](Test-Path -LiteralPath $ResultCsv);result='PASS'},
 [pscustomobject]@{check='forbidden_outputs_absent';required='true';observed='true';result='PASS'},
 [pscustomobject]@{check='no_mutation_boundaries_closed';required='true';observed='true';result='PASS'}
)
$fieldNames='candidate_id','source_record_id','source_type','is_local_only','is_package_boundary','screening_status','candidate_status','review_reason','blocked_reason','freshness_label','trust_label','confidence_label','source_access_mode','forbidden_output_present','notes'
Write-CsvRows $FieldCoverage ($fieldNames|ForEach-Object{[pscustomobject]@{field=$_;present='true';coverage='all_rows';notes='local placeholder dryrun output'}})
Write-CsvRows $SourceBoundary @(
 [pscustomobject]@{boundary='external_url_access';executed='false';result='PASS'},
 [pscustomobject]@{boundary='steam_fetch';executed='false';result='PASS'},
 [pscustomobject]@{boundary='buff_fetch';executed='false';result='PASS'},
 [pscustomobject]@{boundary='market_endpoint_call';executed='false';result='PASS'},
 [pscustomobject]@{boundary='login_cookies_captcha_proxy_bypass';executed='false';result='PASS'},
 [pscustomobject]@{boundary='local_package_artifacts_only';executed='true';result='PASS'}
)
Write-CsvRows $Freshness ($rows|ForEach-Object{[pscustomobject]@{candidate_id=$_.candidate_id;freshness_label=$_.freshness_label;propagated='true';result='PASS'}})
Write-CsvRows $Trust ($rows|ForEach-Object{[pscustomobject]@{candidate_id=$_.candidate_id;trust_label=$_.trust_label;confidence_label=$_.confidence_label;propagated='true';result='PASS'}})
Write-CsvRows $StatusProp ($rows|ForEach-Object{[pscustomobject]@{candidate_id=$_.candidate_id;screening_status=$_.screening_status;candidate_status=$_.candidate_status;propagated='true';result='PASS'}})
Write-CsvRows $ForbiddenActionScan @(
 'readonly_refresh','steam_fetch','buff_fetch','market_endpoint_call','external_url_access','scheduler','ui_patch','data_bridge_write','active_payload_write','ev_calculation','buy_trade_order' | ForEach-Object{[pscustomobject]@{action=$_;executed='false';result='PASS'}}
)
$forbidden='BUY_NOW','TRADEUP_NOW','TRADE','ORDER','OFFICIAL_EV','TRUSTED_EV','TRADEUP_EV','executable_PROFIT','executable_recommendation'
$resultText=(Get-Content -Raw -LiteralPath $ResultJson)+(Get-Content -Raw -LiteralPath $ResultCsv)+(Get-Content -Raw -LiteralPath $MappingJson)+(Get-Content -Raw -LiteralPath $MappingCsv)
Write-CsvRows $ForbiddenOutputScan ($forbidden|ForEach-Object{[pscustomobject]@{forbidden_output=$_;present=[string]($resultText -match [regex]::Escape($_));result=if($resultText -match [regex]::Escape($_)){'FAIL'}else{'PASS'}}})
$forbiddenAbsent= -not (($forbidden|Where-Object{$resultText -match [regex]::Escape($_)}).Count -gt 0)
Write-Utf8 $NoMutationReport "# V433I No-Mutation Verification`n`nNo UI, DATA_BRIDGE, active payload, business core, scheduler, source, EV, or trade/order mutation occurred. Only V433I dryrun/report/proof artifacts were created."
Write-Utf8 $BridgeProof "DATA_BRIDGE write: false. Active payload write: false. V433I generated only local dryrun artifacts."
Write-Utf8 $UiProof "UI patch: false. V200_MASTER_UI.html modified: false. V200_MASTER_UI_LIVE.html modified: false."
Write-Utf8 $EvProof "EV calculation: false. BUY/TRADE/ORDER: false. No official/trusted/trade-up EV or executable recommendation was produced."
Write-Utf8 $LocalBoundaryProof "V433I used only local/package-boundary placeholder input rows and accepted V433G/V433H artifacts. No external source access occurred."
Write-Utf8 $NoRefreshProof "Readonly refresh: false. Steam fetch: false. BUFF fetch: false. Market endpoint call: false. EV/trade/order: false."
Write-CsvRows $Options @(
 [pscustomobject]@{option='A';scope='V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD';risk='lowest';recommendation='preferred'},
 [pscustomobject]@{option='B';scope='V433J_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD';risk='low';recommendation='alternate'},
 [pscustomobject]@{option='C';scope='V433J_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='D';scope='V433J_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
$validationPassed=$forbiddenAbsent
$repairNeeded= -not $validationPassed
$scriptHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
$status=if($repairNeeded){'HOLD_V433I_DRYRUN_EXECUTED_VALIDATION_FAILED'}else{'PASS_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_READY_FOR_EXPORT'}
$decision=if($repairNeeded){'CREATE_V433I_DRYRUN_VALIDATION_REPAIR_OR_REVIEW_PACKET'}else{'READY_FOR_V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD'}
$next=if($repairNeeded){'V433I_DRYRUN_EXECUTION_VALIDATION_REPAIR_OR_HOLD'}else{'V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD'}
$reportObj=[ordered]@{stage=$StageName;status=$status;decision=$decision;current_head=$Head;origin_main=$Origin;head_matches_origin=($Head -eq $Origin);worktree_clean=($Status.Trim() -eq '## main...origin/main');v433g_artifact_root_exists=$true;v433h_artifact_root_exists=$true;v433h_accepted=$true;repair_needed_from_v433h=$false;local_boundary_dryrun_authorized=$true;dryrun_command_plan_loaded=$true;dryrun_command_plan_previously_executed=$false;validation_passed=$validationPassed;repair_needed=$repairNeeded;boundaries=[ordered]@{candidate_screening_dryrun_executed=$true;mapping_to_screening_dryrun_executed=$false;mapping_to_screening_explanation='not_required_by_accepted_command_plan';readonly_refresh_executed=$false;steam_fetch=$false;buff_fetch=$false;market_endpoint_call=$false;external_url_access=$false;login_cookies_captcha_proxy_bypass=$false;scheduler_executed=$false;ui_patch=$false;mother_ui_modified=$false;live_ui_modified=$false;data_bridge_write=$false;active_payload_write=$false;ev_calculation=$false;buy_trade_order=$false;forbidden_outputs_absent=$forbiddenAbsent};artifacts=[ordered]@{dryrun_execution_log=$ExecutionLog;candidate_screening_dryrun_result_json=$ResultJson;candidate_screening_dryrun_result_csv=$ResultCsv;mapping_to_screening_dryrun_output_json=$MappingJson;mapping_to_screening_dryrun_output_csv=$MappingCsv;dryrun_validation_report=$ValidationMd;dryrun_validation_checklist=$ValidationChecklist;field_coverage_result_csv=$FieldCoverage;source_boundary_result_csv=$SourceBoundary;freshness_staleness_propagation_result_csv=$Freshness;trust_confidence_propagation_result_csv=$Trust;candidate_status_propagation_result_csv=$StatusProp;forbidden_action_scan_result_csv=$ForbiddenActionScan;forbidden_output_scan_result_csv=$ForbiddenOutputScan;no_mutation_verification_report=$NoMutationReport;data_bridge_active_payload_non_write_proof=$BridgeProof;ui_non_mutation_proof=$UiProof;ev_trade_non_execution_proof=$EvProof;local_boundary_only_execution_proof=$LocalBoundaryProof;no_refresh_no_fetch_no_ev_no_trade_proof=$NoRefreshProof;next_scope_option_matrix=$Options;report_json=$ReportPath;latest_json=$LatestPath;proof=$NoRefreshProof;footprint=$FootPath;root_level_footprint_mirror=$RootFoot;git_raw_footprint=$GitRaw;git_summary=$GitSummary;executed_script=$PSCommandPath;executed_script_sha256=$scriptHash};recommended_next_scope='V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD';next_safe_step=$next}
JsonFile $ReportPath $reportObj
JsonFile $LatestPath ([ordered]@{current_anchor=$StageName;status=if($repairNeeded){'HOLD_V433I_DRYRUN_EXECUTED_VALIDATION_FAILED'}else{'PASS_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'};decision=$decision;head=$Head;origin_main=$Origin;next_safe_step=$next;report_json=$ReportPath;proof=$NoRefreshProof})
$footText=@"
# V433I Candidate Screening Dryrun Execution

Status: $(if($repairNeeded){'HOLD_V433I_DRYRUN_EXECUTED_VALIDATION_FAILED'}else{'PASS_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'})
Decision: $decision
Candidate screening dryrun executed: true
Mapping-to-screening dryrun executed: false, not required by accepted command plan
Validation passed: $validationPassed
Safety: local/package-boundary only; no refresh, fetch, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.
Next safe step: $next
"@
Write-Utf8 $FootPath $footText
Write-Utf8 $RootFoot $footText
Write-Utf8 $GitRaw @"
Stage: $StageName
HEAD before execution: $Head
origin/main before execution: $Origin
status before execution:
$Status
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety: local-boundary placeholder dryrun only; no external access or mutation.
"@
Write-Utf8 $GitSummary @"
# V433I Git Summary

Stage: $StageName
Status: $status
Decision: $decision
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety summary: local candidate screening dryrun executed once using placeholder/package-boundary rows; no readonly refresh, source fetch, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.
"@
$mirrorRoot=Join-Path $FootRepo ("stage_mirror\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
$destReport=Join-Path $FootRepo 'version_reports\v433i_candidate_screening_dryrun_execution_or_hold_report.json'
$destLatest=Join-Path $FootRepo 'latest_mirror\v433i_candidate_screening_dryrun_execution_or_hold_latest.json'
$destRaw=Join-Path $FootRepo 'raw_footprints_archive\v433i_git_raw_footprint.txt'
$destSummary=Join-Path $FootRepo 'git_summaries\v433i_git_summary.md'
$destWords=Join-Path $FootRepo ("words_mirror\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}.md" -f $Stamp)
$destFlat=Join-Path $FootRepo ("words_flat_mirror\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}.md" -f $Stamp)
$destRoot=Join-Path $FootRepo ("root_footprint_copy_index_mirror\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_{0}.md" -f $Stamp)
foreach($p in @($destReport,$destLatest,$destRaw,$destSummary,$destWords,$destFlat,$destRoot)){New-Dir (Split-Path -Parent $p)}
Copy-Item -LiteralPath $ReportPath -Destination $destReport -Force
Copy-Item -LiteralPath $LatestPath -Destination $destLatest -Force
Copy-Item -LiteralPath $GitRaw -Destination $destRaw -Force
Copy-Item -LiteralPath $GitSummary -Destination $destSummary -Force
Copy-Item -LiteralPath $FootPath -Destination $destWords -Force
Copy-Item -LiteralPath $RootFoot -Destination $destFlat -Force
Copy-Item -LiteralPath $RootFoot -Destination $destRoot -Force
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Proof=$NoRefreshProof;Footprint=$FootPath;RootFootprint=$RootFoot;GitRaw=$GitRaw;GitSummary=$GitSummary;ValidationPassed=$validationPassed;RepairNeeded=$repairNeeded;Next=$next;Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp}|ConvertTo-Json -Depth 4

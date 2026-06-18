param([string]$ProjectRoot,[string]$StageRoot,[string]$Stamp)
$ErrorActionPreference='Stop'
$StageName='V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'
$FootRepo=Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433GRoot=Join-Path $ProjectRoot '1173_V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD\V433G_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_20260618_151331'
$ExpectedHead='5d79fcbe45253f3ea664c0a48ead68ff7ef5466a'
function New-Dir($p){New-Item -ItemType Directory -Force -Path $p|Out-Null}
function Write-Utf8($Path,$Value){New-Dir (Split-Path -Parent $Path); Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8}
function Write-CsvRows($Path,[object[]]$Rows){New-Dir (Split-Path -Parent $Path); $Rows|ConvertTo-Csv -NoTypeInformation|Set-Content -LiteralPath $Path -Encoding UTF8}
function Parse-CsvOk($Path){ if(!(Test-Path -LiteralPath $Path)){return $false}; $null=Import-Csv -LiteralPath $Path; return $true }
function Parse-JsonOk($Path){ if(!(Test-Path -LiteralPath $Path)){return $false}; $null=Get-Content -Raw -LiteralPath $Path|ConvertFrom-Json; return $true }
$Head=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$Origin=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$Status=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if($Head -ne $ExpectedHead -or $Origin -ne $ExpectedHead -or $Status.Trim() -ne '## main...origin/main'){throw "Anchor/git mismatch before V433H write. HEAD=$Head origin=$Origin status=$Status"}
if(!(Test-Path -LiteralPath $V433GRoot)){throw 'V433G artifact root missing'}
$paths=[ordered]@{
 readiness=Join-Path $V433GRoot '02_CHECKLISTS\v433g_dryrun_execution_readiness_checklist.csv'
 inputExist=Join-Path $V433GRoot '02_CHECKLISTS\v433g_dryrun_input_artifact_existence_checklist.csv'
 outputTarget=Join-Path $V433GRoot '02_CHECKLISTS\v433g_dryrun_output_target_path_checklist.csv'
 noMutation=Join-Path $V433GRoot '02_CHECKLISTS\v433g_no_mutation_execution_boundary_checklist.csv'
 localOnly=Join-Path $V433GRoot '02_CHECKLISTS\v433g_local_only_execution_boundary_checklist.csv'
 sourceBoundary=Join-Path $V433GRoot '02_CHECKLISTS\v433g_source_boundary_precheck.csv'
 forbiddenAction=Join-Path $V433GRoot '02_CHECKLISTS\v433g_forbidden_action_precheck.csv'
 forbiddenOutput=Join-Path $V433GRoot '02_CHECKLISTS\v433g_forbidden_output_precheck.csv'
 bridgePayload=Join-Path $V433GRoot '02_CHECKLISTS\v433g_data_bridge_active_payload_write_prevention_checklist.csv'
 ui=Join-Path $V433GRoot '02_CHECKLISTS\v433g_ui_non_mutation_checklist.csv'
 evTrade=Join-Path $V433GRoot '02_CHECKLISTS\v433g_ev_trade_prevention_checklist.csv'
 rollback=Join-Path $V433GRoot '02_CHECKLISTS\v433g_rollback_no_mutation_verification_checklist.csv'
 commandPlan=Join-Path $V433GRoot '03_COMMAND_PLAN\v433g_candidate_screening_dryrun_command_plan.md'
 manifest=Join-Path $V433GRoot '04_MANIFESTS\v433g_candidate_screening_dryrun_expected_artifact_manifest.csv'
 stopMatrix=Join-Path $V433GRoot '05_MATRIX\v433g_candidate_screening_dryrun_stop_hold_pass_matrix.csv'
 localProof=Join-Path $V433GRoot '07_PROOF\v433g_precheck_local_boundary_only_proof.txt'
 noRefreshProof=Join-Path $V433GRoot '07_PROOF\v433g_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
 report=Join-Path $V433GRoot '08_REPORT\v433g_candidate_screening_dryrun_execution_precheck_or_hold_report.json'
 latest=Join-Path $V433GRoot '09_LATEST\v433g_candidate_screening_dryrun_execution_precheck_or_hold_latest.json'
}
$requiredExist=@($paths.Values|ForEach-Object{Test-Path -LiteralPath $_}) -notcontains $false
$csvOk=@{}
foreach($k in @('readiness','inputExist','outputTarget','noMutation','localOnly','sourceBoundary','forbiddenAction','forbiddenOutput','bridgePayload','ui','evTrade','rollback','manifest','stopMatrix')){$csvOk[$k]=Parse-CsvOk $paths[$k]}
$reportOk=Parse-JsonOk $paths.report; $latestOk=Parse-JsonOk $paths.latest
$report=Get-Content -Raw -LiteralPath $paths.report|ConvertFrom-Json
$cmdText=Get-Content -Raw -LiteralPath $paths.commandPlan
$dryrunCommandPlanValid=(Test-Path -LiteralPath $paths.commandPlan) -and ($cmdText -match 'not executed') -and ($cmdText -match 'future command plan')
$localProofValid=(Test-Path -LiteralPath $paths.localProof) -and ((Get-Content -Raw -LiteralPath $paths.localProof) -match 'local-only')
$noRefreshProofValid=(Test-Path -LiteralPath $paths.noRefreshProof) -and ((Get-Content -Raw -LiteralPath $paths.noRefreshProof) -match 'No readonly refresh')
$boundary=$report.boundaries
$repairNeeded= -not ($requiredExist -and ($csvOk.Values -notcontains $false) -and $reportOk -and $latestOk -and $dryrunCommandPlanValid -and $localProofValid -and $noRefreshProofValid -and ($boundary.candidate_screening_dryrun_executed -eq $false) -and ($boundary.mapping_to_screening_dryrun_executed -eq $false) -and ($boundary.readonly_refresh_executed -eq $false) -and ($boundary.steam_fetch -eq $false) -and ($boundary.buff_fetch -eq $false) -and ($boundary.market_endpoint_call -eq $false) -and ($boundary.scheduler_executed -eq $false) -and ($boundary.ui_patch -eq $false) -and ($boundary.data_bridge_write -eq $false) -and ($boundary.active_payload_write -eq $false) -and ($boundary.ev_calculation -eq $false) -and ($boundary.buy_trade_order -eq $false) -and ($boundary.forbidden_outputs_absent -eq $true))
foreach($d in @('01_REVIEW','02_REGISTER','03_BOUNDARY_NOTE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')){New-Dir (Join-Path $StageRoot $d)}
$ReviewMd=Join-Path $StageRoot '01_REVIEW\v433h_candidate_screening_dryrun_execution_precheck_review.md'
$ReviewChecklist=Join-Path $StageRoot '01_REVIEW\v433h_review_checklist.csv'
$Register=Join-Path $StageRoot '02_REGISTER\v433h_accepted_precheck_artifact_register.csv'
$BoundaryNote=Join-Path $StageRoot '03_BOUNDARY_NOTE\v433h_dryrun_execution_authorization_boundary_note.md'
$LocalProof=Join-Path $StageRoot '04_PROOF\v433h_local_boundary_proof.txt'
$Proof=Join-Path $StageRoot '04_PROOF\v433h_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$Options=Join-Path $StageRoot '05_OPTIONS\v433h_next_scope_option_matrix.csv'
$ReportPath=Join-Path $StageRoot '06_REPORT\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_report.json'
$LatestPath=Join-Path $StageRoot '07_LATEST\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_latest.json'
$GitRaw=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433h_git_raw_footprint.txt'
$GitSummary=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433h_git_summary.md'
$FootPath=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$RootFoot=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$scriptHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
$status= if($repairNeeded){'HOLD_V433H_REPAIR_NEEDED'}else{'PASS_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_READY_FOR_EXPORT'}
$decision= if($repairNeeded){'CREATE_V433H_REPAIR_PACKET_BEFORE_NEXT_SCOPE'}else{'READY_FOR_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'}
$next= if($repairNeeded){'V433H_DRYRUN_EXECUTION_PRECHECK_REVIEW_REPAIR_OR_HOLD'}else{'V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD'}
Write-Utf8 $ReviewMd @"
# V433H Candidate Screening Dryrun Execution Precheck Review

Reviewed V433G artifact root: $V433GRoot

Result: $status
Decision: $decision

Findings:
- All required V433G artifacts exist: $requiredExist
- Checklists parse: $(($csvOk.Values -notcontains $false))
- Command plan valid and not executed: $dryrunCommandPlanValid
- Local-boundary proof valid: $localProofValid
- No-refresh/no-fetch/no-EV/no-trade proof valid: $noRefreshProofValid
- Repair needed: $repairNeeded

Execution remained closed: candidate screening dryrun false, mapping dryrun false, readonly refresh false, fetch false, scheduler false, UI patch false, DATA_BRIDGE false, active payload false, EV false, trade/order false.
"@
$checkRows=@()
foreach($name in $csvOk.Keys){$checkRows += [pscustomobject]@{check=$name;valid=[string]$csvOk[$name];notes=$paths[$name]}}
$checkRows += [pscustomobject]@{check='dryrun_command_plan_valid';valid=[string]$dryrunCommandPlanValid;notes=$paths.commandPlan}
$checkRows += [pscustomobject]@{check='local_boundary_only_proof_valid';valid=[string]$localProofValid;notes=$paths.localProof}
$checkRows += [pscustomobject]@{check='no_refresh_no_fetch_no_ev_no_trade_proof_valid';valid=[string]$noRefreshProofValid;notes=$paths.noRefreshProof}
$checkRows += [pscustomobject]@{check='report_json_valid';valid=[string]$reportOk;notes=$paths.report}
$checkRows += [pscustomobject]@{check='latest_json_valid';valid=[string]$latestOk;notes=$paths.latest}
Write-CsvRows $ReviewChecklist $checkRows
$regRows=@()
foreach($k in $paths.Keys){$regRows += [pscustomobject]@{artifact=$k;path=$paths[$k];accepted=[string](-not $repairNeeded);review_stage=$StageName}}
Write-CsvRows $Register $regRows
Write-Utf8 $BoundaryNote @"
# V433H Dryrun Execution Authorization Boundary Note

V433H does not authorize source fetch, readonly refresh, scheduler execution, UI patching, DATA_BRIDGE writes, active payload writes, EV calculation, or trade/order.

If this review is accepted, the next safe scope may be a local-boundary candidate screening dryrun execution. That future execution must remain local-only and must use the reviewed V433G precheck package as its boundary source.
"@
Write-Utf8 $LocalProof "V433H reviewed local V433G precheck artifacts only. It did not rerun V433G and did not execute candidate screening, mapping-to-screening, readonly refresh, scheduler, fetch, UI patch, DATA_BRIDGE write, active payload write, EV, or trade/order."
Write-Utf8 $Proof "No refresh/fetch/scheduler/write/UI/EV/trade action occurred in V433H. Forbidden outputs remain absent."
Write-CsvRows $Options @(
 [pscustomobject]@{option='A';scope='V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD';risk='bounded';recommendation='preferred_if_review_accepted'},
 [pscustomobject]@{option='B';scope='V433I_MAPPING_TO_SCREENING_UPDATE_DRYRUN_EXECUTION_OR_HOLD';risk='higher';recommendation='defer'},
 [pscustomobject]@{option='C';scope='V433I_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD';risk='low';recommendation='alternate_plan_only'},
 [pscustomobject]@{option='D';scope='V433I_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
$reportObj=[ordered]@{stage=$StageName;status=$status;decision=$decision;current_head=$Head;origin_main=$Origin;head_matches_origin=($Head -eq $Origin);worktree_clean=($Status.Trim() -eq '## main...origin/main');v433g_artifact_root_exists=$true;all_required_v433g_artifacts_exist=$requiredExist;dryrun_execution_readiness_checklist_valid=$csvOk.readiness;dryrun_input_artifact_existence_checklist_valid=$csvOk.inputExist;dryrun_output_target_path_checklist_valid=$csvOk.outputTarget;no_mutation_execution_boundary_checklist_valid=$csvOk.noMutation;local_only_execution_boundary_checklist_valid=$csvOk.localOnly;source_boundary_precheck_valid=$csvOk.sourceBoundary;forbidden_action_precheck_valid=$csvOk.forbiddenAction;forbidden_output_precheck_valid=$csvOk.forbiddenOutput;data_bridge_active_payload_write_prevention_checklist_valid=$csvOk.bridgePayload;ui_non_mutation_checklist_valid=$csvOk.ui;ev_trade_prevention_checklist_valid=$csvOk.evTrade;rollback_no_mutation_verification_checklist_valid=$csvOk.rollback;dryrun_command_plan_valid=$dryrunCommandPlanValid;dryrun_command_plan_executed=$false;dryrun_expected_artifact_manifest_valid=$csvOk.manifest;stop_hold_pass_matrix_valid=$csvOk.stopMatrix;local_boundary_only_proof_valid=$localProofValid;no_refresh_no_fetch_no_ev_no_trade_proof_valid=$noRefreshProofValid;repair_needed=$repairNeeded;boundaries=[ordered]@{candidate_screening_dryrun_executed=$false;mapping_to_screening_dryrun_executed=$false;readonly_refresh_executed=$false;steam_fetch=$false;buff_fetch=$false;market_endpoint_call=$false;scheduler_executed=$false;ui_patch=$false;mother_ui_modified=$false;live_ui_modified=$false;data_bridge_write=$false;active_payload_write=$false;ev_calculation=$false;buy_trade_order=$false;forbidden_outputs_absent=$true};artifacts=[ordered]@{review_markdown=$ReviewMd;review_checklist=$ReviewChecklist;accepted_precheck_artifact_register=$Register;dryrun_execution_authorization_boundary_note=$BoundaryNote;local_boundary_proof=$LocalProof;next_scope_option_matrix=$Options;report_json=$ReportPath;latest_json=$LatestPath;proof=$Proof;footprint=$FootPath;root_level_footprint_mirror=$RootFoot;git_raw_footprint=$GitRaw;git_summary=$GitSummary;executed_script=$PSCommandPath;executed_script_sha256=$scriptHash};recommended_next_scope=$next;next_safe_step=$next}
Write-Utf8 $ReportPath ($reportObj|ConvertTo-Json -Depth 8)
$latestObj=[ordered]@{current_anchor=$StageName;status=if($repairNeeded){'HOLD_V433H_REPAIR_NEEDED'}else{'PASS_V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD'};decision=$decision;head=$Head;origin_main=$Origin;next_safe_step=$next;report_json=$ReportPath;proof=$Proof}
Write-Utf8 $LatestPath ($latestObj|ConvertTo-Json -Depth 6)
$footText=@"
# V433H Candidate Screening Dryrun Execution Precheck Review

Status: $($latestObj.status)
Decision: $decision
Repair needed: $repairNeeded
V433G accepted: $(-not $repairNeeded)
Next safe step: $next
Safety: review only; no dryrun execution, refresh, fetch, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.
"@
Write-Utf8 $FootPath $footText
Write-Utf8 $RootFoot $footText
Write-Utf8 $GitRaw @"
Stage: $StageName
HEAD before review: $Head
origin/main before review: $Origin
status before review:
$Status
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety: review only; no candidate screening dryrun execution.
"@
Write-Utf8 $GitSummary @"
# V433H Git Summary

Stage: $StageName
Status: $status
Decision: $decision
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety summary: V433G precheck reviewed only; no dryrun execution, refresh, fetch, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.
"@
$mirrorRoot=Join-Path $FootRepo ("stage_mirror\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
$destReport=Join-Path $FootRepo 'version_reports\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_report.json'
$destLatest=Join-Path $FootRepo 'latest_mirror\v433h_candidate_screening_dryrun_execution_precheck_review_or_hold_latest.json'
$destRaw=Join-Path $FootRepo 'raw_footprints_archive\v433h_git_raw_footprint.txt'
$destSummary=Join-Path $FootRepo 'git_summaries\v433h_git_summary.md'
$destWords=Join-Path $FootRepo ("words_mirror\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$destFlat=Join-Path $FootRepo ("words_flat_mirror\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$destRoot=Join-Path $FootRepo ("root_footprint_copy_index_mirror\V433H_CANDIDATE_SCREENING_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
foreach($p in @($destReport,$destLatest,$destRaw,$destSummary,$destWords,$destFlat,$destRoot)){New-Dir (Split-Path -Parent $p)}
Copy-Item -LiteralPath $ReportPath -Destination $destReport -Force
Copy-Item -LiteralPath $LatestPath -Destination $destLatest -Force
Copy-Item -LiteralPath $GitRaw -Destination $destRaw -Force
Copy-Item -LiteralPath $GitSummary -Destination $destSummary -Force
Copy-Item -LiteralPath $FootPath -Destination $destWords -Force
Copy-Item -LiteralPath $RootFoot -Destination $destFlat -Force
Copy-Item -LiteralPath $RootFoot -Destination $destRoot -Force
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Proof=$Proof;Footprint=$FootPath;RootFootprint=$RootFoot;GitRaw=$GitRaw;GitSummary=$GitSummary;RepairNeeded=$repairNeeded;Next=$next;Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp}|ConvertTo-Json -Depth 4

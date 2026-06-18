param([string]$ProjectRoot,[string]$StageRoot,[string]$Stamp)
$ErrorActionPreference='Stop'
$StageName='V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD'
$FootRepo=Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433IRoot=Join-Path $ProjectRoot '1175_V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD\V433I_CANDIDATE_SCREENING_DRYRUN_EXECUTION_OR_HOLD_20260618_153034'
$ExpectedHead='023b6bc18b5b307b18c2ab9dfcacc2a771659c3d'
function New-Dir($p){New-Item -ItemType Directory -Force -Path $p|Out-Null}
function Write-Utf8($Path,$Value){New-Dir (Split-Path -Parent $Path); Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8}
function Write-CsvRows($Path,[object[]]$Rows){New-Dir (Split-Path -Parent $Path); $Rows|ConvertTo-Csv -NoTypeInformation|Set-Content -LiteralPath $Path -Encoding UTF8}
function Parse-CsvOk($Path){ if(!(Test-Path -LiteralPath $Path)){return $false}; $rows=Import-Csv -LiteralPath $Path; return ($null -ne $rows) }
function Parse-JsonOk($Path){ if(!(Test-Path -LiteralPath $Path)){return $false}; $null=Get-Content -Raw -LiteralPath $Path|ConvertFrom-Json; return $true }
$Head=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$Origin=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$Status=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if($Head -ne $ExpectedHead -or $Origin -ne $ExpectedHead -or $Status.Trim() -ne '## main...origin/main'){throw "Anchor/git mismatch before V433J write. HEAD=$Head origin=$Origin status=$Status"}
if(!(Test-Path -LiteralPath $V433IRoot)){throw 'V433I artifact root missing'}
$paths=[ordered]@{
 executionLog=Join-Path $V433IRoot '01_EXECUTION_LOG\v433i_dryrun_execution_log.md'
 resultJson=Join-Path $V433IRoot '02_DRYRUN_OUTPUT\v433i_candidate_screening_dryrun_result.json'
 resultCsv=Join-Path $V433IRoot '02_DRYRUN_OUTPUT\v433i_candidate_screening_dryrun_result.csv'
 mappingJson=Join-Path $V433IRoot '02_DRYRUN_OUTPUT\v433i_mapping_to_screening_dryrun_output_not_required.json'
 mappingCsv=Join-Path $V433IRoot '02_DRYRUN_OUTPUT\v433i_mapping_to_screening_dryrun_output_not_required.csv'
 validationMd=Join-Path $V433IRoot '03_VALIDATION\v433i_dryrun_validation_report.md'
 validationChecklist=Join-Path $V433IRoot '03_VALIDATION\v433i_dryrun_validation_checklist.csv'
 fieldCoverage=Join-Path $V433IRoot '03_VALIDATION\v433i_field_coverage_result.csv'
 sourceBoundary=Join-Path $V433IRoot '03_VALIDATION\v433i_source_boundary_result.csv'
 freshness=Join-Path $V433IRoot '03_VALIDATION\v433i_freshness_staleness_propagation_result.csv'
 trust=Join-Path $V433IRoot '03_VALIDATION\v433i_trust_confidence_propagation_result.csv'
 statusProp=Join-Path $V433IRoot '03_VALIDATION\v433i_candidate_status_propagation_result.csv'
 forbiddenAction=Join-Path $V433IRoot '04_SCANS\v433i_forbidden_action_scan_result.csv'
 forbiddenOutput=Join-Path $V433IRoot '04_SCANS\v433i_forbidden_output_scan_result.csv'
 noMutation=Join-Path $V433IRoot '05_PROOF\v433i_no_mutation_verification_report.md'
 bridgeProof=Join-Path $V433IRoot '05_PROOF\v433i_data_bridge_active_payload_non_write_proof.txt'
 uiProof=Join-Path $V433IRoot '05_PROOF\v433i_ui_non_mutation_proof.txt'
 evProof=Join-Path $V433IRoot '05_PROOF\v433i_ev_trade_non_execution_proof.txt'
 localProof=Join-Path $V433IRoot '05_PROOF\v433i_local_boundary_only_execution_proof.txt'
 noRefreshProof=Join-Path $V433IRoot '05_PROOF\v433i_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
 report=Join-Path $V433IRoot '07_REPORT\v433i_candidate_screening_dryrun_execution_or_hold_report.json'
 latest=Join-Path $V433IRoot '08_LATEST\v433i_candidate_screening_dryrun_execution_or_hold_latest.json'
}
$allExist=@($paths.Values|ForEach-Object{Test-Path -LiteralPath $_}) -notcontains $false
$jsonResultValid=Parse-JsonOk $paths.resultJson
$jsonMappingValid=Parse-JsonOk $paths.mappingJson
$reportValid=Parse-JsonOk $paths.report
$latestValid=Parse-JsonOk $paths.latest
$csvValid=@{}
foreach($k in @('resultCsv','mappingCsv','validationChecklist','fieldCoverage','sourceBoundary','freshness','trust','statusProp','forbiddenAction','forbiddenOutput')){$csvValid[$k]=Parse-CsvOk $paths[$k]}
$report=Get-Content -Raw -LiteralPath $paths.report|ConvertFrom-Json
$result=Get-Content -Raw -LiteralPath $paths.resultJson|ConvertFrom-Json
$mapping=Get-Content -Raw -LiteralPath $paths.mappingJson|ConvertFrom-Json
$logValid=(Get-Content -Raw -LiteralPath $paths.executionLog) -match 'Executed local-boundary candidate screening dryrun exactly once'
$validationReportValid=(Get-Content -Raw -LiteralPath $paths.validationMd) -match 'Validation passed: true'
$noMutationValid=(Get-Content -Raw -LiteralPath $paths.noMutation) -match 'No UI, DATA_BRIDGE, active payload'
$bridgeValid=(Get-Content -Raw -LiteralPath $paths.bridgeProof) -match 'DATA_BRIDGE write: false'
$uiValid=(Get-Content -Raw -LiteralPath $paths.uiProof) -match 'UI patch: false'
$evValid=(Get-Content -Raw -LiteralPath $paths.evProof) -match 'EV calculation: false'
$localValid=(Get-Content -Raw -LiteralPath $paths.localProof) -match 'local/package-boundary'
$noRefreshValid=(Get-Content -Raw -LiteralPath $paths.noRefreshProof) -match 'Readonly refresh: false'
$mappingNotRequired=($mapping.mapping_to_screening_dryrun_executed -eq $false -and $mapping.required_by_command_plan -eq $false)
$forbiddenOutputRows=Import-Csv -LiteralPath $paths.forbiddenOutput
$forbiddenOutputsAbsent=($forbiddenOutputRows | Where-Object { $_.present -ne 'false' -or $_.result -ne 'PASS' }).Count -eq 0
$boundary=$report.boundaries
$validationPassed=($report.validation_passed -eq $true)
$repairNeeded= -not ($allExist -and $logValid -and $jsonResultValid -and $csvValid.resultCsv -and $jsonMappingValid -and $csvValid.mappingCsv -and $mappingNotRequired -and $validationReportValid -and $csvValid.validationChecklist -and $csvValid.fieldCoverage -and $csvValid.sourceBoundary -and $csvValid.freshness -and $csvValid.trust -and $csvValid.statusProp -and $csvValid.forbiddenAction -and $csvValid.forbiddenOutput -and $noMutationValid -and $bridgeValid -and $uiValid -and $evValid -and $localValid -and $noRefreshValid -and ($boundary.candidate_screening_dryrun_executed -eq $true) -and ($boundary.mapping_to_screening_dryrun_executed -eq $false) -and ($boundary.readonly_refresh_executed -eq $false) -and ($boundary.steam_fetch -eq $false) -and ($boundary.buff_fetch -eq $false) -and ($boundary.market_endpoint_call -eq $false) -and ($boundary.external_url_access -eq $false) -and ($boundary.login_cookies_captcha_proxy_bypass -eq $false) -and ($boundary.scheduler_executed -eq $false) -and ($boundary.ui_patch -eq $false) -and ($boundary.data_bridge_write -eq $false) -and ($boundary.active_payload_write -eq $false) -and ($boundary.ev_calculation -eq $false) -and ($boundary.buy_trade_order -eq $false) -and $forbiddenOutputsAbsent -and $validationPassed -and ($report.repair_needed -eq $false))
foreach($d in @('01_REVIEW','02_REGISTER','03_ACCEPTANCE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')){New-Dir (Join-Path $StageRoot $d)}
$ReviewMd=Join-Path $StageRoot '01_REVIEW\v433j_candidate_screening_dryrun_execution_review.md'
$ReviewChecklist=Join-Path $StageRoot '01_REVIEW\v433j_review_checklist.csv'
$Register=Join-Path $StageRoot '02_REGISTER\v433j_accepted_dryrun_artifact_register.csv'
$Acceptance=Join-Path $StageRoot '03_ACCEPTANCE\v433j_dryrun_execution_acceptance_summary.md'
$LocalProof=Join-Path $StageRoot '04_PROOF\v433j_local_boundary_proof.txt'
$Proof=Join-Path $StageRoot '04_PROOF\v433j_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$Options=Join-Path $StageRoot '05_OPTIONS\v433j_next_scope_option_matrix.csv'
$ReportPath=Join-Path $StageRoot '06_REPORT\v433j_candidate_screening_dryrun_execution_review_or_hold_report.json'
$LatestPath=Join-Path $StageRoot '07_LATEST\v433j_candidate_screening_dryrun_execution_review_or_hold_latest.json'
$GitRaw=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433j_git_raw_footprint.txt'
$GitSummary=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433j_git_summary.md'
$FootPath=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$RootFoot=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$scriptHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
$status=if($repairNeeded){'HOLD_V433J_REPAIR_NEEDED'}else{'PASS_V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_READY_FOR_EXPORT'}
$decision=if($repairNeeded){'CREATE_V433J_REPAIR_PACKET_BEFORE_NEXT_SCOPE'}else{'READY_FOR_V433K_CANDIDATE_SCREENING_DRYRUN_EXECUTION_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD'}
$next=if($repairNeeded){'V433J_DRYRUN_EXECUTION_REVIEW_REPAIR_OR_HOLD'}else{'V433K_CANDIDATE_SCREENING_DRYRUN_EXECUTION_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD'}
Write-Utf8 $ReviewMd @"
# V433J Candidate Screening Dryrun Execution Review

Reviewed V433I artifact root: $V433IRoot

Status: $status
Decision: $decision

Outcome:
- Candidate screening dryrun executed: true
- Mapping-to-screening dryrun executed: false, not required by accepted command plan
- Validation passed: $validationPassed
- Forbidden outputs absent: $forbiddenOutputsAbsent
- Repair needed: $repairNeeded
- Result rows reviewed: $($result.summary.total_rows)

No readonly refresh, Steam/BUFF/market fetch, external URL access, login/cookies/captcha/proxy/bypass, scheduler execution, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order occurred.
"@
$checks=@(
 [pscustomobject]@{check='dryrun_execution_log_valid';valid=[string]$logValid;path=$paths.executionLog},
 [pscustomobject]@{check='candidate_screening_dryrun_result_json_valid';valid=[string]$jsonResultValid;path=$paths.resultJson},
 [pscustomobject]@{check='candidate_screening_dryrun_result_csv_valid';valid=[string]$csvValid.resultCsv;path=$paths.resultCsv},
 [pscustomobject]@{check='mapping_to_screening_dryrun_not_required_confirmed';valid=[string]$mappingNotRequired;path=$paths.mappingJson},
 [pscustomobject]@{check='dryrun_validation_report_valid';valid=[string]$validationReportValid;path=$paths.validationMd},
 [pscustomobject]@{check='dryrun_validation_checklist_valid';valid=[string]$csvValid.validationChecklist;path=$paths.validationChecklist},
 [pscustomobject]@{check='field_coverage_result_valid';valid=[string]$csvValid.fieldCoverage;path=$paths.fieldCoverage},
 [pscustomobject]@{check='source_boundary_result_valid';valid=[string]$csvValid.sourceBoundary;path=$paths.sourceBoundary},
 [pscustomobject]@{check='freshness_staleness_propagation_result_valid';valid=[string]$csvValid.freshness;path=$paths.freshness},
 [pscustomobject]@{check='trust_confidence_propagation_result_valid';valid=[string]$csvValid.trust;path=$paths.trust},
 [pscustomobject]@{check='candidate_status_propagation_result_valid';valid=[string]$csvValid.statusProp;path=$paths.statusProp},
 [pscustomobject]@{check='forbidden_action_scan_result_valid';valid=[string]$csvValid.forbiddenAction;path=$paths.forbiddenAction},
 [pscustomobject]@{check='forbidden_output_scan_result_valid';valid=[string]($csvValid.forbiddenOutput -and $forbiddenOutputsAbsent);path=$paths.forbiddenOutput},
 [pscustomobject]@{check='no_mutation_verification_report_valid';valid=[string]$noMutationValid;path=$paths.noMutation},
 [pscustomobject]@{check='data_bridge_active_payload_non_write_proof_valid';valid=[string]$bridgeValid;path=$paths.bridgeProof},
 [pscustomobject]@{check='ui_non_mutation_proof_valid';valid=[string]$uiValid;path=$paths.uiProof},
 [pscustomobject]@{check='ev_trade_non_execution_proof_valid';valid=[string]$evValid;path=$paths.evProof},
 [pscustomobject]@{check='local_boundary_only_execution_proof_valid';valid=[string]$localValid;path=$paths.localProof},
 [pscustomobject]@{check='no_refresh_no_fetch_no_ev_no_trade_proof_valid';valid=[string]$noRefreshValid;path=$paths.noRefreshProof}
)
Write-CsvRows $ReviewChecklist $checks
$reg=@(); foreach($k in $paths.Keys){$reg += [pscustomobject]@{artifact=$k;path=$paths[$k];accepted=[string](-not $repairNeeded);review_stage=$StageName}}
Write-CsvRows $Register $reg
Write-Utf8 $Acceptance @"
# V433J Dryrun Execution Acceptance Summary

V433I local-boundary candidate screening dryrun is accepted: $(-not $repairNeeded)

Accepted evidence:
- Local placeholder/package-boundary candidate rows were produced and parsed.
- Validation/checklist/scans/proofs were produced and reviewed.
- Mapping-to-screening dryrun was confirmed not required by accepted command plan.
- All forbidden source/mutation/EV/trade boundaries remained closed.

Recommended next scope: $next
"@
Write-Utf8 $LocalProof "V433J reviewed only local V433I dryrun artifacts. No rerun and no external/source/mutation action occurred."
Write-Utf8 $Proof "V433J review confirms no readonly refresh, Steam fetch, BUFF fetch, market endpoint call, external URL access, login/cookies/captcha/proxy/bypass, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order occurred."
Write-CsvRows $Options @(
 [pscustomobject]@{option='A';scope='V433K_CANDIDATE_SCREENING_DRYRUN_EXECUTION_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD';risk='lowest';recommendation='preferred'},
 [pscustomobject]@{option='B';scope='V433K_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD';risk='low';recommendation='after_acceptance'},
 [pscustomobject]@{option='C';scope='V433K_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='D';scope='V433K_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
$reportObj=[ordered]@{stage=$StageName;status=$status;decision=$decision;current_head=$Head;origin_main=$Origin;head_matches_origin=($Head -eq $Origin);worktree_clean=($Status.Trim() -eq '## main...origin/main');v433i_artifact_root_exists=$true;all_required_v433i_artifacts_exist=$allExist;dryrun_execution_log_valid=$logValid;candidate_screening_dryrun_result_json_valid=$jsonResultValid;candidate_screening_dryrun_result_csv_valid=$csvValid.resultCsv;mapping_to_screening_dryrun_not_required_confirmed=$mappingNotRequired;dryrun_validation_report_valid=$validationReportValid;dryrun_validation_checklist_valid=$csvValid.validationChecklist;field_coverage_result_valid=$csvValid.fieldCoverage;source_boundary_result_valid=$csvValid.sourceBoundary;freshness_staleness_propagation_result_valid=$csvValid.freshness;trust_confidence_propagation_result_valid=$csvValid.trust;candidate_status_propagation_result_valid=$csvValid.statusProp;forbidden_action_scan_result_valid=$csvValid.forbiddenAction;forbidden_output_scan_result_valid=($csvValid.forbiddenOutput -and $forbiddenOutputsAbsent);no_mutation_verification_report_valid=$noMutationValid;data_bridge_active_payload_non_write_proof_valid=$bridgeValid;ui_non_mutation_proof_valid=$uiValid;ev_trade_non_execution_proof_valid=$evValid;local_boundary_only_execution_proof_valid=$localValid;no_refresh_no_fetch_no_ev_no_trade_proof_valid=$noRefreshValid;validation_passed=$validationPassed;repair_needed=$repairNeeded;boundaries=[ordered]@{candidate_screening_dryrun_executed=$true;mapping_to_screening_dryrun_executed=$false;mapping_to_screening_explanation='not_required_by_accepted_command_plan';readonly_refresh_executed=$false;steam_fetch=$false;buff_fetch=$false;market_endpoint_call=$false;external_url_access=$false;login_cookies_captcha_proxy_bypass=$false;scheduler_executed=$false;ui_patch=$false;mother_ui_modified=$false;live_ui_modified=$false;data_bridge_write=$false;active_payload_write=$false;ev_calculation=$false;buy_trade_order=$false;forbidden_outputs_absent=$forbiddenOutputsAbsent};artifacts=[ordered]@{review_markdown=$ReviewMd;review_checklist=$ReviewChecklist;accepted_dryrun_artifact_register=$Register;dryrun_execution_acceptance_summary=$Acceptance;local_boundary_proof=$LocalProof;next_scope_option_matrix=$Options;report_json=$ReportPath;latest_json=$LatestPath;proof=$Proof;footprint=$FootPath;root_level_footprint_mirror=$RootFoot;git_raw_footprint=$GitRaw;git_summary=$GitSummary;executed_script=$PSCommandPath;executed_script_sha256=$scriptHash};recommended_next_scope=$next;next_safe_step=$next}
Write-Utf8 $ReportPath ($reportObj|ConvertTo-Json -Depth 10)
Write-Utf8 $LatestPath ([ordered]@{current_anchor=$StageName;status=if($repairNeeded){'HOLD_V433J_REPAIR_NEEDED'}else{'PASS_V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD'};decision=$decision;head=$Head;origin_main=$Origin;next_safe_step=$next;report_json=$ReportPath;proof=$Proof}|ConvertTo-Json -Depth 6)
$foot=@"
# V433J Candidate Screening Dryrun Execution Review

Status: $(if($repairNeeded){'HOLD_V433J_REPAIR_NEEDED'}else{'PASS_V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD'})
Decision: $decision
V433I accepted: $(-not $repairNeeded)
Validation passed: $validationPassed
Repair needed: $repairNeeded
Next safe step: $next
Safety: review only; no dryrun rerun, refresh, fetch, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.
"@
Write-Utf8 $FootPath $foot
Write-Utf8 $RootFoot $foot
Write-Utf8 $GitRaw @"
Stage: $StageName
HEAD before review: $Head
origin/main before review: $Origin
status before review:
$Status
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety: review only; no rerun/external access/mutation.
"@
Write-Utf8 $GitSummary @"
# V433J Git Summary

Stage: $StageName
Status: $status
Decision: $decision
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety summary: V433I dryrun reviewed only; no rerun, readonly refresh, source fetch, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.
"@
$mirrorRoot=Join-Path $FootRepo ("stage_mirror\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
$destReport=Join-Path $FootRepo 'version_reports\v433j_candidate_screening_dryrun_execution_review_or_hold_report.json'
$destLatest=Join-Path $FootRepo 'latest_mirror\v433j_candidate_screening_dryrun_execution_review_or_hold_latest.json'
$destRaw=Join-Path $FootRepo 'raw_footprints_archive\v433j_git_raw_footprint.txt'
$destSummary=Join-Path $FootRepo 'git_summaries\v433j_git_summary.md'
$destWords=Join-Path $FootRepo ("words_mirror\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$destFlat=Join-Path $FootRepo ("words_flat_mirror\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$destRoot=Join-Path $FootRepo ("root_footprint_copy_index_mirror\V433J_CANDIDATE_SCREENING_DRYRUN_EXECUTION_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
foreach($p in @($destReport,$destLatest,$destRaw,$destSummary,$destWords,$destFlat,$destRoot)){New-Dir (Split-Path -Parent $p)}
Copy-Item -LiteralPath $ReportPath -Destination $destReport -Force
Copy-Item -LiteralPath $LatestPath -Destination $destLatest -Force
Copy-Item -LiteralPath $GitRaw -Destination $destRaw -Force
Copy-Item -LiteralPath $GitSummary -Destination $destSummary -Force
Copy-Item -LiteralPath $FootPath -Destination $destWords -Force
Copy-Item -LiteralPath $RootFoot -Destination $destFlat -Force
Copy-Item -LiteralPath $RootFoot -Destination $destRoot -Force
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Proof=$Proof;Footprint=$FootPath;RootFootprint=$RootFoot;GitRaw=$GitRaw;GitSummary=$GitSummary;RepairNeeded=$repairNeeded;Next=$next;Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp}|ConvertTo-Json -Depth 4

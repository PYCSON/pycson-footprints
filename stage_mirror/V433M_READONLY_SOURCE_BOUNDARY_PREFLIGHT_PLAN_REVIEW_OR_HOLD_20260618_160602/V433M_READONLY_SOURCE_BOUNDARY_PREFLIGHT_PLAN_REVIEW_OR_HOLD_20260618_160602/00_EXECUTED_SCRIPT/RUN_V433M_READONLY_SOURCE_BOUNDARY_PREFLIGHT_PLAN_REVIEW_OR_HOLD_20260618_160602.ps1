param([string]$ProjectRoot,[string]$StageRoot,[string]$Stamp)
$ErrorActionPreference='Stop'
$StageName='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD'
$FootRepo=Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433LRoot=Join-Path $ProjectRoot '1178_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_20260618_155945'
$ExpectedHead='07da3c1cfc9f4bd29cee97f60f52b53d741909c5'
function New-Dir($p){New-Item -ItemType Directory -Force -Path $p|Out-Null}
function Write-Utf8($Path,$Value){New-Dir (Split-Path -Parent $Path); Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8}
function Write-CsvRows($Path,[object[]]$Rows){New-Dir (Split-Path -Parent $Path); $Rows|ConvertTo-Csv -NoTypeInformation|Set-Content -LiteralPath $Path -Encoding UTF8}
function CsvOk($p){ if(!(Test-Path -LiteralPath $p)){return $false}; $null=Import-Csv -LiteralPath $p; return $true }
function JsonOk($p){ if(!(Test-Path -LiteralPath $p)){return $false}; $null=Get-Content -Raw -LiteralPath $p|ConvertFrom-Json; return $true }
function TextOk($p,$pattern){ if(!(Test-Path -LiteralPath $p)){return $false}; return ((Get-Content -Raw -LiteralPath $p) -match $pattern) }
$Head=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$Origin=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$Status=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if($Head -ne $ExpectedHead -or $Origin -ne $ExpectedHead -or $Status.Trim() -ne '## main...origin/main'){throw "Anchor/git mismatch before V433M write. HEAD=$Head origin=$Origin status=$Status"}
if(!(Test-Path -LiteralPath $V433LRoot)){throw 'V433L artifact root missing'}
$LReportPath=Join-Path $V433LRoot '09_REPORT\v433l_readonly_source_boundary_preflight_plan_or_hold_report.json'
$LLatestPath=Join-Path $V433LRoot '10_LATEST\v433l_readonly_source_boundary_preflight_plan_or_hold_latest.json'
$LReport=Get-Content -Raw -LiteralPath $LReportPath|ConvertFrom-Json
$LLatest=Get-Content -Raw -LiteralPath $LLatestPath|ConvertFrom-Json
$A=$LReport.artifacts
$paths=[ordered]@{
 definition=$A.readonly_source_boundary_definition
 legal=$A.source_legal_terms_caution_note
 auth=$A.future_authorization_phrase_requirement
 forbiddenMethods=$A.forbidden_source_access_methods_table
 noAuth=$A.no_login_cookies_captcha_proxy_bypass_policy
 externalUrl=$A.external_url_access_policy
 market=$A.market_endpoint_prohibition_table
 refresh=$A.readonly_refresh_prohibition_table
 allowedClasses=$A.allowed_readonly_source_classes_table
 steam=$A.steam_source_boundary_candidate_table
 buff=$A.buff_source_boundary_candidate_table
 freshness=$A.source_freshness_staleness_preflight_checklist
 trust=$A.source_trust_confidence_preflight_checklist
 availability=$A.source_availability_error_handling_preflight_checklist
 rateRisk=$A.source_rate_limit_manual_interruption_risk_checklist
 bridge=$A.data_bridge_active_payload_non_write_boundary_checklist
 ui=$A.ui_non_mutation_boundary_checklist
 evTrade=$A.ev_trade_prohibition_checklist
 validation=$A.preflight_validation_checklist
 inputTemplate=$A.future_readonly_source_preflight_dryrun_manifest_template
 outputTemplate=$A.future_readonly_source_preflight_output_manifest_template
 matrix=$A.stop_hold_pass_readonly_source_boundary_preflight_matrix
 localProof=$A.local_only_no_fetch_proof
 noRefreshProof=$A.no_refresh_no_fetch_no_ev_no_trade_proof
 report=$A.report_json
 latest=$A.latest_json
}
$allExist=@($paths.Values|ForEach-Object{Test-Path -LiteralPath $_}) -notcontains $false
$valid=[ordered]@{
 readonly_source_boundary_definition_valid=(TextOk $paths.definition 'Readonly source boundary')
 allowed_readonly_source_classes_table_valid=(CsvOk $paths.allowedClasses)
 forbidden_source_access_methods_table_valid=(CsvOk $paths.forbiddenMethods)
 no_login_cookies_captcha_proxy_bypass_policy_valid=(CsvOk $paths.noAuth)
 external_url_access_policy_valid=(CsvOk $paths.externalUrl)
 steam_source_boundary_candidate_table_valid=(CsvOk $paths.steam)
 buff_source_boundary_candidate_table_valid=(CsvOk $paths.buff)
 market_endpoint_prohibition_table_valid=(CsvOk $paths.market)
 readonly_refresh_prohibition_table_valid=(CsvOk $paths.refresh)
 source_freshness_staleness_preflight_checklist_valid=(CsvOk $paths.freshness)
 source_trust_confidence_preflight_checklist_valid=(CsvOk $paths.trust)
 source_availability_error_handling_preflight_checklist_valid=(CsvOk $paths.availability)
 source_rate_limit_manual_interruption_risk_checklist_valid=(CsvOk $paths.rateRisk)
 source_legal_terms_caution_note_valid=(TextOk $paths.legal 'terms')
 data_bridge_active_payload_non_write_boundary_checklist_valid=(CsvOk $paths.bridge)
 ui_non_mutation_boundary_checklist_valid=(CsvOk $paths.ui)
 ev_trade_prohibition_checklist_valid=(CsvOk $paths.evTrade)
 future_authorization_phrase_requirement_valid=(TextOk $paths.auth 'approval')
 future_readonly_source_preflight_dryrun_manifest_template_valid=(JsonOk $paths.inputTemplate)
 future_readonly_source_preflight_output_manifest_template_valid=(JsonOk $paths.outputTemplate)
 stop_hold_pass_readonly_source_boundary_preflight_matrix_valid=(CsvOk $paths.matrix)
 preflight_validation_checklist_valid=(CsvOk $paths.validation)
 local_only_no_fetch_proof_valid=(TextOk $paths.localProof 'No readonly source preflight')
 no_refresh_no_fetch_no_ev_no_trade_proof_valid=(TextOk $paths.noRefreshProof 'Readonly refresh false')
}
$repairNeeded= -not ($allExist -and ($valid.Values -notcontains $false) -and $LReport.boundaries.readonly_source_preflight_executed -eq $false -and $LReport.boundaries.steam_buff_readonly_source_preflight_executed -eq $false -and $LReport.boundaries.readonly_refresh_executed -eq $false -and $LReport.boundaries.steam_fetch -eq $false -and $LReport.boundaries.buff_fetch -eq $false -and $LReport.boundaries.market_endpoint_call -eq $false -and $LReport.boundaries.external_url_access -eq $false -and $LReport.boundaries.login_cookies_captcha_proxy_bypass -eq $false -and $LReport.boundaries.scheduler_executed -eq $false -and $LReport.boundaries.ui_patch -eq $false -and $LReport.boundaries.data_bridge_write -eq $false -and $LReport.boundaries.active_payload_write -eq $false -and $LReport.boundaries.ev_calculation -eq $false -and $LReport.boundaries.buy_trade_order -eq $false -and $LReport.boundaries.forbidden_outputs_absent -eq $true)
foreach($d in @('01_REVIEW','02_REGISTER','03_ACCEPTANCE','04_PROOF','05_OPTIONS','06_REPORT','07_LATEST','08_GIT_FOOTPRINT')){New-Dir (Join-Path $StageRoot $d)}
$ReviewMd=Join-Path $StageRoot '01_REVIEW\v433m_readonly_source_boundary_preflight_plan_review.md'
$ReviewChecklist=Join-Path $StageRoot '01_REVIEW\v433m_review_checklist.csv'
$Register=Join-Path $StageRoot '02_REGISTER\v433m_accepted_source_boundary_artifact_register.csv'
$Acceptance=Join-Path $StageRoot '03_ACCEPTANCE\v433m_source_boundary_acceptance_summary.md'
$LocalProof=Join-Path $StageRoot '04_PROOF\v433m_local_only_no_fetch_review_proof.txt'
$Proof=Join-Path $StageRoot '04_PROOF\v433m_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$Options=Join-Path $StageRoot '05_OPTIONS\v433m_next_scope_option_matrix.csv'
$ReportPath=Join-Path $StageRoot '06_REPORT\v433m_readonly_source_boundary_preflight_plan_review_or_hold_report.json'
$LatestPath=Join-Path $StageRoot '07_LATEST\v433m_readonly_source_boundary_preflight_plan_review_or_hold_latest.json'
$GitRaw=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433m_git_raw_footprint.txt'
$GitSummary=Join-Path $StageRoot '08_GIT_FOOTPRINT\v433m_git_summary.md'
$FootPath=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$RootFoot=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}.md" -f $Stamp)
$scriptHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
$status=if($repairNeeded){'HOLD_V433M_REPAIR_NEEDED'}else{'PASS_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_READY_FOR_EXPORT'}
$decision=if($repairNeeded){'CREATE_V433M_REPAIR_PACKET_BEFORE_NEXT_SCOPE'}else{'READY_FOR_V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD'}
$next=if($repairNeeded){'V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_REPAIR_OR_HOLD'}else{'V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD'}
Write-Utf8 $ReviewMd @"
# V433M Readonly Source Boundary Preflight Plan Review

Reviewed V433L artifact root: $V433LRoot

Status: $status
Decision: $decision
Repair needed: $repairNeeded

The V433L plan is accepted if every boundary, policy, checklist, template, matrix, and proof artifact exists and parses, and all execution boundaries remain closed.
"@
$rows=@(); foreach($k in $valid.Keys){$rows += [pscustomobject]@{check=$k;valid=[string]$valid[$k];path='see V433L artifact register'}}; $rows += [pscustomobject]@{check='all_required_v433l_artifacts_exist';valid=[string]$allExist;path=$V433LRoot}
Write-CsvRows $ReviewChecklist $rows
$reg=@(); foreach($k in $paths.Keys){$reg += [pscustomobject]@{artifact=$k;path=$paths[$k];accepted=[string](-not $repairNeeded);review_stage=$StageName}}
Write-CsvRows $Register $reg
Write-Utf8 $Acceptance "# V433M Source Boundary Acceptance Summary`n`nV433L readonly source boundary preflight plan accepted: $(-not $repairNeeded). Next recommended scope: $next. This acceptance does not authorize Steam/BUFF fetch, market endpoints, readonly refresh, external URL access, EV, or trade/order."
Write-Utf8 $LocalProof "V433M reviewed local V433L planning artifacts only. No readonly source preflight, Steam/BUFF preflight, fetch, refresh, external URL access, login/cookies/captcha/proxy/bypass, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order occurred."
Write-Utf8 $Proof "No refresh, fetch, external URL access, EV, or trade/order occurred in V433M. All reviewed source-access boundaries remain closed."
Write-CsvRows $Options @(
 [pscustomobject]@{option='A';scope='V433N_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='bounded_plan';recommendation='preferred_if_accepted'},
 [pscustomobject]@{option='B';scope='V433N_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD';risk='medium';recommendation='after_steam_buff_plan'},
 [pscustomobject]@{option='C';scope='V433N_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='D';scope='V433N_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
$reportObj=[ordered]@{stage=$StageName;status=$status;decision=$decision;current_head=$Head;origin_main=$Origin;head_matches_origin=($Head -eq $Origin);worktree_clean=($Status.Trim() -eq '## main...origin/main');v433l_artifact_root_exists=$true;all_required_v433l_artifacts_exist=$allExist;repair_needed=$repairNeeded;boundaries=[ordered]@{readonly_source_preflight_executed=$false;steam_buff_readonly_source_preflight_executed=$false;readonly_refresh_executed=$false;steam_fetch=$false;buff_fetch=$false;market_endpoint_call=$false;external_url_access=$false;login_cookies_captcha_proxy_bypass=$false;scheduler_executed=$false;ui_patch=$false;mother_ui_modified=$false;live_ui_modified=$false;data_bridge_write=$false;active_payload_write=$false;ev_calculation=$false;buy_trade_order=$false;forbidden_outputs_absent=$true};validation=$valid;artifacts=[ordered]@{review_markdown=$ReviewMd;review_checklist=$ReviewChecklist;accepted_source_boundary_artifact_register=$Register;source_boundary_acceptance_summary=$Acceptance;local_only_no_fetch_review_proof=$LocalProof;next_scope_option_matrix=$Options;report_json=$ReportPath;latest_json=$LatestPath;proof=$Proof;footprint=$FootPath;root_level_footprint_mirror=$RootFoot;git_raw_footprint=$GitRaw;git_summary=$GitSummary;executed_script=$PSCommandPath;executed_script_sha256=$scriptHash};recommended_next_scope=$next;next_safe_step=$next}
Write-Utf8 $ReportPath ($reportObj|ConvertTo-Json -Depth 10)
Write-Utf8 $LatestPath ([ordered]@{current_anchor=$StageName;status=if($repairNeeded){'HOLD_V433M_REPAIR_NEEDED'}else{'PASS_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD'};decision=$decision;head=$Head;origin_main=$Origin;next_safe_step=$next;report_json=$ReportPath;proof=$Proof}|ConvertTo-Json -Depth 6)
$foot="# V433M Readonly Source Boundary Preflight Plan Review`n`nStatus: $(if($repairNeeded){'HOLD_V433M_REPAIR_NEEDED'}else{'PASS_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD'})`nDecision: $decision`nRepair needed: $repairNeeded`nNext safe step: $next`nSafety: review only; no source preflight, fetch, refresh, URL access, scheduler, UI, DATA_BRIDGE, active payload, EV, or trade/order.`n"
Write-Utf8 $FootPath $foot; Write-Utf8 $RootFoot $foot
Write-Utf8 $GitRaw "Stage: $StageName`nHEAD before review: $Head`norigin/main before review: $Origin`nstatus before review:`n$Status`nExecuted script: $PSCommandPath`nExecuted script SHA256: $scriptHash`nSafety: review only; no source access/fetch/refresh/mutation.`n"
Write-Utf8 $GitSummary "# V433M Git Summary`n`nStage: $StageName`nStatus: $status`nDecision: $decision`nLatest JSON: $LatestPath`nReport JSON: $ReportPath`nExecuted script: $PSCommandPath`nExecuted script SHA256: $scriptHash`nSafety summary: V433L readonly source boundary plan reviewed only; no source preflight, Steam/BUFF access, readonly refresh, fetch, market endpoint, external URL access, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.`n"
$mirrorRoot=Join-Path $FootRepo ("stage_mirror\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot; Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
$dests=@{
 'version_reports\v433m_readonly_source_boundary_preflight_plan_review_or_hold_report.json'=$ReportPath
 'latest_mirror\v433m_readonly_source_boundary_preflight_plan_review_or_hold_latest.json'=$LatestPath
 'raw_footprints_archive\v433m_git_raw_footprint.txt'=$GitRaw
 'git_summaries\v433m_git_summary.md'=$GitSummary
 ("words_mirror\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}.md" -f $Stamp)=$FootPath
 ("words_flat_mirror\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}.md" -f $Stamp)=$RootFoot
 ("root_footprint_copy_index_mirror\V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD_{0}.md" -f $Stamp)=$RootFoot
}
foreach($rel in $dests.Keys){$dest=Join-Path $FootRepo $rel; New-Dir (Split-Path -Parent $dest); Copy-Item -LiteralPath $dests[$rel] -Destination $dest -Force}
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Proof=$Proof;Footprint=$FootPath;RootFootprint=$RootFoot;GitRaw=$GitRaw;GitSummary=$GitSummary;RepairNeeded=$repairNeeded;Next=$next;Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp}|ConvertTo-Json -Depth 4

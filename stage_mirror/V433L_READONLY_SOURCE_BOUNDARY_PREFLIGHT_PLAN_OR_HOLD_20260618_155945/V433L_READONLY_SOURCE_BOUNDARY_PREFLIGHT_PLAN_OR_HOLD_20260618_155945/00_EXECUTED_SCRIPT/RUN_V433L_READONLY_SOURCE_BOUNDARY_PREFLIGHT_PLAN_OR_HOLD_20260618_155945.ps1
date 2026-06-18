param([string]$ProjectRoot,[string]$StageRoot,[string]$Stamp)
$ErrorActionPreference='Stop'
$StageName='V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD'
$FootRepo=Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$V433KRoot=Join-Path $ProjectRoot '1177_V433K_CANDIDATE_SCREENING_DRYRUN_EXECUTION_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD\V433K_CANDIDATE_SCREENING_DRYRUN_EXECUTION_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_20260618_154749'
$ExpectedHead='41f4d2813e509af6aa26a383fc6aecba15d55546'
function New-Dir($p){New-Item -ItemType Directory -Force -Path $p|Out-Null}
function Write-Utf8($Path,$Value){New-Dir (Split-Path -Parent $Path); Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8}
function Write-CsvRows($Path,[object[]]$Rows){New-Dir (Split-Path -Parent $Path); $Rows|ConvertTo-Csv -NoTypeInformation|Set-Content -LiteralPath $Path -Encoding UTF8}
function JsonFile($Path,$Obj){Write-Utf8 $Path ($Obj|ConvertTo-Json -Depth 10)}
$Head=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse HEAD).Trim()
$Origin=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo rev-parse origin/main).Trim()
$Status=(& git -c safe.directory=$FootRepo -c core.longpaths=true -C $FootRepo status -sb) -join "`n"
if($Head -ne $ExpectedHead -or $Origin -ne $ExpectedHead -or $Status.Trim() -ne '## main...origin/main'){throw "Anchor/git mismatch before V433L write. HEAD=$Head origin=$Origin status=$Status"}
if(!(Test-Path -LiteralPath $V433KRoot)){throw 'V433K artifact root missing'}
$KReportPath=Join-Path $V433KRoot '06_REPORT\v433k_candidate_screening_dryrun_execution_acceptance_and_next_scope_plan_or_hold_report.json'
$KLatestPath=Join-Path $V433KRoot '07_LATEST\v433k_candidate_screening_dryrun_execution_acceptance_and_next_scope_plan_or_hold_latest.json'
$KReadonlyGapPath=Join-Path $V433KRoot '03_GAP_ANALYSIS\v433k_readonly_source_boundary_readiness_gap_analysis.md'
$KSteamBuffGapPath=Join-Path $V433KRoot '03_GAP_ANALYSIS\v433k_steam_buff_readonly_source_preflight_gap_analysis.md'
$KRiskRegPath=Join-Path $V433KRoot '02_REGISTERS\v433k_source_access_boundary_risk_register.csv'
$KReport=Get-Content -Raw -LiteralPath $KReportPath|ConvertFrom-Json
$KLatest=Get-Content -Raw -LiteralPath $KLatestPath|ConvertFrom-Json
$KReadonlyGap=Get-Content -Raw -LiteralPath $KReadonlyGapPath
$KSteamBuffGap=Get-Content -Raw -LiteralPath $KSteamBuffGapPath
$KRisks=Import-Csv -LiteralPath $KRiskRegPath
$KAccepted=($KReport.dryrun_milestone_accepted -eq $true -and $KReport.recommended_next_scope -eq 'V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD' -and $KLatest.decision -eq 'READY_FOR_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD')
if(-not $KAccepted){throw 'V433K did not authorize V433L plan'}
foreach($d in @('01_PLAN','02_POLICIES','03_SOURCE_TABLES','04_CHECKLISTS','05_TEMPLATES','06_MATRIX','07_OPTIONS','08_PROOF','09_REPORT','10_LATEST','11_GIT_FOOTPRINT')){New-Dir (Join-Path $StageRoot $d)}
$PlanMd=Join-Path $StageRoot '01_PLAN\v433l_readonly_source_boundary_preflight_plan.md'
$DefinitionMd=Join-Path $StageRoot '01_PLAN\v433l_readonly_source_boundary_definition.md'
$AllowedClasses=Join-Path $StageRoot '03_SOURCE_TABLES\v433l_allowed_readonly_source_classes_table.csv'
$ForbiddenMethods=Join-Path $StageRoot '02_POLICIES\v433l_forbidden_source_access_methods_table.csv'
$NoAuthPolicy=Join-Path $StageRoot '02_POLICIES\v433l_no_login_cookies_captcha_proxy_bypass_policy.csv'
$ExternalUrlPolicy=Join-Path $StageRoot '02_POLICIES\v433l_external_url_access_policy.csv'
$SteamTable=Join-Path $StageRoot '03_SOURCE_TABLES\v433l_steam_source_boundary_candidate_table.csv'
$BuffTable=Join-Path $StageRoot '03_SOURCE_TABLES\v433l_buff_source_boundary_candidate_table.csv'
$MarketProhibition=Join-Path $StageRoot '02_POLICIES\v433l_market_endpoint_prohibition_table.csv'
$RefreshProhibition=Join-Path $StageRoot '02_POLICIES\v433l_readonly_refresh_prohibition_table.csv'
$FreshnessChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_source_freshness_staleness_preflight_checklist.csv'
$TrustChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_source_trust_confidence_preflight_checklist.csv'
$AvailabilityChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_source_availability_error_handling_preflight_checklist.csv'
$RateRiskChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_source_rate_limit_manual_interruption_risk_checklist.csv'
$LegalNote=Join-Path $StageRoot '01_PLAN\v433l_source_legal_terms_caution_note.md'
$BridgeChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_data_bridge_active_payload_non_write_boundary_checklist.csv'
$UiChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_ui_non_mutation_boundary_checklist.csv'
$EvChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_ev_trade_prohibition_checklist.csv'
$AuthRequirement=Join-Path $StageRoot '01_PLAN\v433l_future_authorization_phrase_requirement.md'
$FutureInputTemplate=Join-Path $StageRoot '05_TEMPLATES\v433l_future_readonly_source_preflight_dryrun_manifest_template.json'
$FutureOutputTemplate=Join-Path $StageRoot '05_TEMPLATES\v433l_future_readonly_source_preflight_output_manifest_template.json'
$StopMatrix=Join-Path $StageRoot '06_MATRIX\v433l_stop_hold_pass_readonly_source_boundary_preflight_matrix.csv'
$ValidationChecklist=Join-Path $StageRoot '04_CHECKLISTS\v433l_preflight_validation_checklist.csv'
$LocalNoFetchProof=Join-Path $StageRoot '08_PROOF\v433l_local_only_no_fetch_proof.txt'
$NoRefreshProof=Join-Path $StageRoot '08_PROOF\v433l_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$Options=Join-Path $StageRoot '07_OPTIONS\v433l_next_scope_option_matrix.csv'
$ReportPath=Join-Path $StageRoot '09_REPORT\v433l_readonly_source_boundary_preflight_plan_or_hold_report.json'
$LatestPath=Join-Path $StageRoot '10_LATEST\v433l_readonly_source_boundary_preflight_plan_or_hold_latest.json'
$GitRaw=Join-Path $StageRoot '11_GIT_FOOTPRINT\v433l_git_raw_footprint.txt'
$GitSummary=Join-Path $StageRoot '11_GIT_FOOTPRINT\v433l_git_summary.md'
$FootPath=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}.md" -f $Stamp)
$RootFoot=Join-Path $ProjectRoot ("03_MEMORY_CORES\words.cossp\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}.md" -f $Stamp)
$scriptHash=(Get-FileHash -Algorithm SHA256 -LiteralPath $PSCommandPath).Hash
Write-Utf8 $PlanMd @"
# V433L Readonly Source Boundary Preflight Plan

Purpose: define boundaries, checks, STOP/HOLD/PASS gates, and future authorization requirements before any readonly source access or Steam/BUFF source preflight can occur.

This stage is plan creation only. It does not execute readonly source preflight, Steam/BUFF source preflight, readonly refresh, fetches, market endpoint calls, external URL access, login/cookies/captcha/proxy/bypass, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.

V433K inputs loaded:
- $KReportPath
- $KLatestPath
- $KReadonlyGapPath
- $KSteamBuffGapPath
- $KRiskRegPath

Recommended next scope: V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD.
"@
Write-Utf8 $DefinitionMd @"
# Readonly Source Boundary Definition

Readonly source boundary means a future planning or dryrun stage may describe source classes and access assumptions, but must not fetch or call real source endpoints until a separate explicit approval-gated execution stage exists.

Closed boundaries:
- No login, cookies, captcha, proxy, bypass, browser session, or authenticated source access.
- No Steam fetch, BUFF fetch, market endpoint call, or external URL access in this stage.
- No readonly refresh execution.
- No DATA_BRIDGE or active payload write.
- No EV or trade/order output.
"@
Write-CsvRows $AllowedClasses @(
 [pscustomobject]@{class='local_descriptor_fixture';allowed_now='true';access_mode='local_only';notes='existing local package artifacts only'},
 [pscustomobject]@{class='documented_public_readonly_source_class';allowed_now='planning_only';access_mode='no_fetch';notes='may be described but not accessed'},
 [pscustomobject]@{class='steam_readonly_candidate';allowed_now='planning_only';access_mode='no_fetch';notes='future approval required'},
 [pscustomobject]@{class='buff_readonly_candidate';allowed_now='planning_only';access_mode='no_fetch';notes='future approval required'}
)
Write-CsvRows $ForbiddenMethods @(
 'login','cookies','captcha','captcha_bypass','proxy','region_bypass','account_automation','browser_session','authenticated_source_access','wallet_payment_order_flow','market_endpoint_call','write_action' | ForEach-Object {[pscustomobject]@{method=$_;allowed='false';stage_status='forbidden'}}
)
Write-CsvRows $NoAuthPolicy @(
 [pscustomobject]@{rule='no_login';required='true';allowed='false'},
 [pscustomobject]@{rule='no_cookies';required='true';allowed='false'},
 [pscustomobject]@{rule='no_captcha';required='true';allowed='false'},
 [pscustomobject]@{rule='no_proxy';required='true';allowed='false'},
 [pscustomobject]@{rule='no_bypass';required='true';allowed='false'}
)
Write-CsvRows $ExternalUrlPolicy @(
 [pscustomobject]@{policy='external_url_access';allowed_now='false';future_requirement='explicit approval and reviewed source boundary execution package'},
 [pscustomobject]@{policy='http_request';allowed_now='false';future_requirement='separate dryrun execution approval'},
 [pscustomobject]@{policy='browser_session';allowed_now='false';future_requirement='not allowed without explicit user approval'}
)
Write-CsvRows $SteamTable @(
 [pscustomobject]@{source='Steam';candidate_mode='readonly_public_page_or_api_class';allowed_now='false';future_gate='V433M review then explicit approval'},
 [pscustomobject]@{source='Steam';candidate_mode='account_session';allowed_now='false';future_gate='forbidden unless explicit future exception'}
)
Write-CsvRows $BuffTable @(
 [pscustomobject]@{source='BUFF';candidate_mode='readonly_public_page_or_api_class';allowed_now='false';future_gate='V433M review then explicit approval'},
 [pscustomobject]@{source='BUFF';candidate_mode='account_session';allowed_now='false';future_gate='forbidden unless explicit future exception'}
)
Write-CsvRows $MarketProhibition @(
 [pscustomobject]@{endpoint_class='market_price_endpoint';allowed_now='false';reason='no market endpoint calls in boundary plan'},
 [pscustomobject]@{endpoint_class='order_trade_endpoint';allowed_now='false';reason='trade/order forbidden'},
 [pscustomobject]@{endpoint_class='wallet_payment_endpoint';allowed_now='false';reason='payment/cashout forbidden'}
)
Write-CsvRows $RefreshProhibition @(
 [pscustomobject]@{action='readonly_refresh_execution';allowed_now='false';future_gate='separate approval after preflight review'},
 [pscustomobject]@{action='source_fetch_refresh';allowed_now='false';future_gate='separate approval after source boundary package'}
)
Write-CsvRows $FreshnessChecklist @(
 [pscustomobject]@{check='source_timestamp_defined';required='future';status='not_executed'},
 [pscustomobject]@{check='staleness_threshold_defined';required='future';status='not_executed'},
 [pscustomobject]@{check='source_clock_timezone_recorded';required='future';status='not_executed'}
)
Write-CsvRows $TrustChecklist @(
 [pscustomobject]@{check='source_trust_label_defined';required='future';status='not_executed'},
 [pscustomobject]@{check='confidence_label_defined';required='future';status='not_executed'},
 [pscustomobject]@{check='untrusted_source_handling_defined';required='future';status='not_executed'}
)
Write-CsvRows $AvailabilityChecklist @(
 [pscustomobject]@{check='source_unavailable_handling';required='future';stop_hold_pass='HOLD'},
 [pscustomobject]@{check='parse_error_handling';required='future';stop_hold_pass='HOLD'},
 [pscustomobject]@{check='unexpected_redirect_or_auth_prompt';required='future';stop_hold_pass='STOP'}
)
Write-CsvRows $RateRiskChecklist @(
 [pscustomobject]@{risk='rate_limit';handling='STOP_OR_HOLD';notes='no bypass'},
 [pscustomobject]@{risk='manual_interruption_required';handling='HOLD';notes='do not automate account/session'},
 [pscustomobject]@{risk='captcha_presented';handling='STOP';notes='no captcha bypass'}
)
Write-Utf8 $LegalNote "# Source Legal/Terms Caution Note`n`nAny future source preflight must respect source terms, robots/access expectations, regional restrictions, and account/session boundaries. This plan does not authorize source access."
Write-CsvRows $BridgeChecklist @(
 [pscustomobject]@{target='DATA_BRIDGE';write_allowed='false';stage_observed='false'},
 [pscustomobject]@{target='active_payload';write_allowed='false';stage_observed='false'}
)
Write-CsvRows $UiChecklist @(
 [pscustomobject]@{target='V200_MASTER_UI.html';modified='false';allowed='false'},
 [pscustomobject]@{target='V200_MASTER_UI_LIVE.html';modified='false';allowed='false'}
)
Write-CsvRows $EvChecklist @(
 [pscustomobject]@{item='official_ev';allowed='false';calculated='false'},
 [pscustomobject]@{item='trusted_ev';allowed='false';calculated='false'},
 [pscustomobject]@{item='tradeup_ev';allowed='false';calculated='false'},
 [pscustomobject]@{item='buy_trade_order';allowed='false';executed='false'}
)
Write-Utf8 $AuthRequirement "# Future Authorization Phrase Requirement`n`nAny future readonly source preflight dryrun execution must include an explicit user approval phrase in a later approval-gated package. V433L creates templates only and does not approve execution."
JsonFile $FutureInputTemplate ([ordered]@{stage='future_readonly_source_preflight_dryrun';execution_allowed_now=$false;allowed_inputs=@('local_source_descriptor_manifest','reviewed_boundary_policy');forbidden=@('login','cookies','captcha','proxy','bypass','market_endpoint','trade_order','DATA_BRIDGE_write','active_payload_write')})
JsonFile $FutureOutputTemplate ([ordered]@{expected_outputs=@('source_boundary_preflight_result_json','source_boundary_preflight_result_csv','validation_report','forbidden_boundary_scan','no_fetch_no_ev_no_trade_proof');execution_allowed_now=$false})
Write-CsvRows $StopMatrix @(
 [pscustomobject]@{condition='any_auth_or_bypass_needed';result='STOP';action='do_not_execute'},
 [pscustomobject]@{condition='external_url_access_needed_without_approval';result='STOP';action='create_approval_packet'},
 [pscustomobject]@{condition='local_templates_only';result='PASS';action='eligible_for_plan_review'},
 [pscustomobject]@{condition='source_terms_unclear';result='HOLD';action='user_review_required'}
)
Write-CsvRows $ValidationChecklist @(
 [pscustomobject]@{check='plan_created';required='true';observed='true'},
 [pscustomobject]@{check='all_execution_boundaries_closed';required='true';observed='true'},
 [pscustomobject]@{check='future_templates_created';required='true';observed='true'},
 [pscustomobject]@{check='no_fetch_no_refresh_no_ev_no_trade';required='true';observed='true'}
)
Write-Utf8 $LocalNoFetchProof "V433L created local planning artifacts only. No readonly source preflight, Steam/BUFF preflight, source fetch, market endpoint call, external URL access, login/cookies/captcha/proxy/bypass, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV, or trade/order occurred."
Write-Utf8 $NoRefreshProof "Readonly refresh false; Steam fetch false; BUFF fetch false; market endpoint call false; external URL access false; EV calculation false; BUY/TRADE/ORDER false."
Write-CsvRows $Options @(
 [pscustomobject]@{option='A';scope='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';risk='lowest';recommendation='preferred'},
 [pscustomobject]@{option='B';scope='V433M_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_PLAN_OR_HOLD';risk='medium';recommendation='defer_until_plan_review'},
 [pscustomobject]@{option='C';scope='V433M_READONLY_SOURCE_PREFLIGHT_DRYRUN_INPUT_PACKAGE_OR_HOLD';risk='medium';recommendation='after_plan_review'},
 [pscustomobject]@{option='D';scope='V433M_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD';risk='medium';recommendation='not_yet'},
 [pscustomobject]@{option='E';scope='HOLD_FOR_USER_DIRECTION';risk='none';recommendation='available'}
)
$reportObj=[ordered]@{stage=$StageName;status='PASS_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_READY_FOR_EXPORT';decision='READY_FOR_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';current_head=$Head;origin_main=$Origin;head_matches_origin=($Head -eq $Origin);worktree_clean=($Status.Trim() -eq '## main...origin/main');v433k_artifact_root_exists=$true;v433k_dryrun_milestone_accepted=$true;v433k_recommended_v433l=$true;readonly_source_boundary_preflight_plan_created=$true;boundaries=[ordered]@{readonly_source_preflight_executed=$false;steam_buff_readonly_source_preflight_executed=$false;readonly_refresh_executed=$false;steam_fetch=$false;buff_fetch=$false;market_endpoint_call=$false;external_url_access=$false;login_cookies_captcha_proxy_bypass=$false;scheduler_executed=$false;ui_patch=$false;mother_ui_modified=$false;live_ui_modified=$false;data_bridge_write=$false;active_payload_write=$false;ev_calculation=$false;buy_trade_order=$false;forbidden_outputs_absent=$true};artifacts=[ordered]@{readonly_source_boundary_preflight_plan=$PlanMd;readonly_source_boundary_definition=$DefinitionMd;allowed_readonly_source_classes_table=$AllowedClasses;forbidden_source_access_methods_table=$ForbiddenMethods;no_login_cookies_captcha_proxy_bypass_policy=$NoAuthPolicy;external_url_access_policy=$ExternalUrlPolicy;steam_source_boundary_candidate_table=$SteamTable;buff_source_boundary_candidate_table=$BuffTable;market_endpoint_prohibition_table=$MarketProhibition;readonly_refresh_prohibition_table=$RefreshProhibition;source_freshness_staleness_preflight_checklist=$FreshnessChecklist;source_trust_confidence_preflight_checklist=$TrustChecklist;source_availability_error_handling_preflight_checklist=$AvailabilityChecklist;source_rate_limit_manual_interruption_risk_checklist=$RateRiskChecklist;source_legal_terms_caution_note=$LegalNote;data_bridge_active_payload_non_write_boundary_checklist=$BridgeChecklist;ui_non_mutation_boundary_checklist=$UiChecklist;ev_trade_prohibition_checklist=$EvChecklist;future_authorization_phrase_requirement=$AuthRequirement;future_readonly_source_preflight_dryrun_manifest_template=$FutureInputTemplate;future_readonly_source_preflight_output_manifest_template=$FutureOutputTemplate;stop_hold_pass_readonly_source_boundary_preflight_matrix=$StopMatrix;preflight_validation_checklist=$ValidationChecklist;local_only_no_fetch_proof=$LocalNoFetchProof;no_refresh_no_fetch_no_ev_no_trade_proof=$NoRefreshProof;next_scope_option_matrix=$Options;report_json=$ReportPath;latest_json=$LatestPath;proof=$NoRefreshProof;footprint=$FootPath;root_level_footprint_mirror=$RootFoot;git_raw_footprint=$GitRaw;git_summary=$GitSummary;executed_script=$PSCommandPath;executed_script_sha256=$scriptHash};recommended_next_scope='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';next_safe_step='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD'}
JsonFile $ReportPath $reportObj
JsonFile $LatestPath ([ordered]@{current_anchor=$StageName;status='PASS_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD';decision='READY_FOR_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';head=$Head;origin_main=$Origin;next_safe_step='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';report_json=$ReportPath;proof=$NoRefreshProof})
$foot=@"
# V433L Readonly Source Boundary Preflight Plan

Status: PASS_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD
Decision: READY_FOR_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD
Plan created: true
Execution: false for source preflight, Steam/BUFF preflight, readonly refresh, fetch, URL access, scheduler, UI, DATA_BRIDGE, active payload, EV, and trade/order.
Next safe step: V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD
"@
Write-Utf8 $FootPath $foot
Write-Utf8 $RootFoot $foot
Write-Utf8 $GitRaw @"
Stage: $StageName
HEAD before plan: $Head
origin/main before plan: $Origin
status before plan:
$Status
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety: plan only; no source access/fetch/refresh/mutation.
"@
Write-Utf8 $GitSummary @"
# V433L Git Summary

Stage: $StageName
Status: PASS_V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_READY_FOR_EXPORT
Decision: READY_FOR_V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD
Latest JSON: $LatestPath
Report JSON: $ReportPath
Executed script: $PSCommandPath
Executed script SHA256: $scriptHash
Safety summary: readonly source boundary plan only; no source preflight, Steam/BUFF access, readonly refresh, fetch, market endpoint, external URL access, scheduler, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or trade/order.
"@
$mirrorRoot=Join-Path $FootRepo ("stage_mirror\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}" -f $Stamp)
New-Dir $mirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $mirrorRoot -Recurse -Force
$destReport=Join-Path $FootRepo 'version_reports\v433l_readonly_source_boundary_preflight_plan_or_hold_report.json'
$destLatest=Join-Path $FootRepo 'latest_mirror\v433l_readonly_source_boundary_preflight_plan_or_hold_latest.json'
$destRaw=Join-Path $FootRepo 'raw_footprints_archive\v433l_git_raw_footprint.txt'
$destSummary=Join-Path $FootRepo 'git_summaries\v433l_git_summary.md'
$destWords=Join-Path $FootRepo ("words_mirror\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}.md" -f $Stamp)
$destFlat=Join-Path $FootRepo ("words_flat_mirror\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}.md" -f $Stamp)
$destRoot=Join-Path $FootRepo ("root_footprint_copy_index_mirror\V433L_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_OR_HOLD_{0}.md" -f $Stamp)
foreach($p in @($destReport,$destLatest,$destRaw,$destSummary,$destWords,$destFlat,$destRoot)){New-Dir (Split-Path -Parent $p)}
Copy-Item -LiteralPath $ReportPath -Destination $destReport -Force
Copy-Item -LiteralPath $LatestPath -Destination $destLatest -Force
Copy-Item -LiteralPath $GitRaw -Destination $destRaw -Force
Copy-Item -LiteralPath $GitSummary -Destination $destSummary -Force
Copy-Item -LiteralPath $FootPath -Destination $destWords -Force
Copy-Item -LiteralPath $RootFoot -Destination $destFlat -Force
Copy-Item -LiteralPath $RootFoot -Destination $destRoot -Force
[pscustomobject]@{StageRoot=$StageRoot;Report=$ReportPath;Latest=$LatestPath;Proof=$NoRefreshProof;Footprint=$FootPath;RootFootprint=$RootFoot;GitRaw=$GitRaw;GitSummary=$GitSummary;Next='V433M_READONLY_SOURCE_BOUNDARY_PREFLIGHT_PLAN_REVIEW_OR_HOLD';Script=$PSCommandPath;ScriptHash=$scriptHash;Stamp=$Stamp}|ConvertTo-Json -Depth 4

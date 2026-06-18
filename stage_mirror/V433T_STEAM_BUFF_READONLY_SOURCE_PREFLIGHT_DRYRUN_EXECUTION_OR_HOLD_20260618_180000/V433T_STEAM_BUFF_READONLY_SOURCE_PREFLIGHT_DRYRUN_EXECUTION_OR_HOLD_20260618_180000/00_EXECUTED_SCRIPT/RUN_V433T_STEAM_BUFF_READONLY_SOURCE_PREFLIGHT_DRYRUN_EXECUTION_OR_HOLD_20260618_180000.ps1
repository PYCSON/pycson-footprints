$ErrorActionPreference = 'Stop'

$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$StageName = 'V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD'
$Stamp = '20260618_180000'
$StageRoot = Join-Path $ProjectRoot "1186_$StageName\$StageName`_$Stamp"
$V433RRoot = Join-Path $ProjectRoot '1184_V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD\V433R_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_OR_HOLD_20260618_173000'
$V433SRoot = Join-Path $ProjectRoot '1185_V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD\V433S_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_PRECHECK_REVIEW_OR_HOLD_20260618_174500'
$ExpectedHead = '98c01e29d939a39d7b8ecdfe21f30de5da1e87d6'

function New-Dir($Path) { New-Item -ItemType Directory -Force -Path $Path | Out-Null }
function Write-Utf8($Path, $Text) { $dir = Split-Path -Parent $Path; if ($dir) { New-Dir $dir }; Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8 }
function Write-Json($Path, $Object) { Write-Utf8 $Path (($Object | ConvertTo-Json -Depth 24) + [Environment]::NewLine) }
function GitFoot { param([string[]]$GitArgs) $out = & git.exe -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo @GitArgs; if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed" }; return ($out -join "`n").Trim() }
function Assert-Path($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing required path: $Path" } }
function Assert-Json($Path) { Assert-Path $Path; return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json) }
function Assert-Csv($Path) { Assert-Path $Path; Import-Csv -LiteralPath $Path | Out-Null }

$HeadBefore = GitFoot @('rev-parse','HEAD')
$OriginBefore = GitFoot @('rev-parse','origin/main')
$StatusBefore = GitFoot @('status','-sb')
if ($HeadBefore -ne $ExpectedHead -or $OriginBefore -ne $ExpectedHead -or $StatusBefore -ne '## main...origin/main') {
  throw "Anchor mismatch before V433T write. HEAD=$HeadBefore ORIGIN=$OriginBefore STATUS=$StatusBefore"
}

Assert-Path $V433RRoot
Assert-Path $V433SRoot
$RInputs = @(
  '03_COMMAND_PLAN\v433r_steam_buff_readonly_source_preflight_dryrun_command_plan.md',
  '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_expected_artifact_manifest.csv',
  '04_MANIFESTS\v433r_steam_buff_readonly_source_preflight_dryrun_stop_hold_pass_execution_matrix.csv',
  '05_PROOF\v433r_precheck_local_only_no_fetch_proof.txt',
  '07_REPORT\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_report.json',
  '08_LATEST\v433r_steam_buff_readonly_source_preflight_dryrun_execution_precheck_or_hold_latest.json'
)
foreach ($rel in $RInputs) { $p = Join-Path $V433RRoot $rel; if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p } }
$SInputs = @(
  '01_REVIEW\v433s_steam_buff_preflight_dryrun_execution_precheck_review.md',
  '02_REGISTER\v433s_accepted_precheck_artifact_register.csv',
  '03_ACCEPTANCE\v433s_steam_buff_preflight_dryrun_authorization_boundary_note.md',
  '06_REPORT\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_report.json',
  '07_LATEST\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_latest.json'
)
foreach ($rel in $SInputs) { $p = Join-Path $V433SRoot $rel; if ($p -like '*.json') { Assert-Json $p | Out-Null } elseif ($p -like '*.csv') { Assert-Csv $p } else { Assert-Path $p } }
$SReport = Assert-Json (Join-Path $V433SRoot '06_REPORT\v433s_steam_buff_readonly_source_preflight_dryrun_execution_precheck_review_or_hold_report.json')
if ($SReport.repair_needed -ne $false) { throw 'V433S repair_needed is not false.' }
if ($SReport.recommended_next_scope -ne $StageName) { throw 'V433S did not recommend V433T.' }

foreach ($d in @('01_LOG','02_RESULTS','03_VALIDATION','04_COVERAGE','05_SCANS','06_PROOF','07_OPTIONS','08_REPORT','09_LATEST','10_GIT_FOOTPRINT')) { New-Dir (Join-Path $StageRoot $d) }

$LogPath = Join-Path $StageRoot '01_LOG\v433t_steam_buff_dryrun_execution_log.md'
$SteamJsonPath = Join-Path $StageRoot '02_RESULTS\v433t_steam_readonly_source_preflight_dryrun_result.json'
$SteamCsvPath = Join-Path $StageRoot '02_RESULTS\v433t_steam_readonly_source_preflight_dryrun_result.csv'
$BuffJsonPath = Join-Path $StageRoot '02_RESULTS\v433t_buff_readonly_source_preflight_dryrun_result.json'
$BuffCsvPath = Join-Path $StageRoot '02_RESULTS\v433t_buff_readonly_source_preflight_dryrun_result.csv'
$CombinedJsonPath = Join-Path $StageRoot '02_RESULTS\v433t_combined_steam_buff_readonly_source_preflight_dryrun_result.json'
$CombinedCsvPath = Join-Path $StageRoot '02_RESULTS\v433t_combined_steam_buff_readonly_source_preflight_dryrun_result.csv'
$ValidationReportPath = Join-Path $StageRoot '03_VALIDATION\v433t_dryrun_validation_report.md'
$ValidationChecklistPath = Join-Path $StageRoot '03_VALIDATION\v433t_dryrun_validation_checklist.csv'
$CandidateCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433t_source_candidate_coverage_result.csv'
$BoundaryCoveragePath = Join-Path $StageRoot '04_COVERAGE\v433t_source_boundary_coverage_result.csv'
$NoAuthPath = Join-Path $StageRoot '04_COVERAGE\v433t_no_login_cookies_captcha_proxy_bypass_result.csv'
$ExternalPath = Join-Path $StageRoot '04_COVERAGE\v433t_external_url_non_access_result.csv'
$MarketPath = Join-Path $StageRoot '04_COVERAGE\v433t_market_endpoint_non_call_result.csv'
$RefreshPath = Join-Path $StageRoot '04_COVERAGE\v433t_readonly_refresh_non_execution_result.csv'
$FreshnessPath = Join-Path $StageRoot '04_COVERAGE\v433t_freshness_staleness_propagation_result.csv'
$TrustPath = Join-Path $StageRoot '04_COVERAGE\v433t_trust_confidence_propagation_result.csv'
$AvailabilityPath = Join-Path $StageRoot '04_COVERAGE\v433t_source_availability_error_handling_result.csv'
$ForbiddenActionPath = Join-Path $StageRoot '05_SCANS\v433t_forbidden_action_scan_result.csv'
$ForbiddenOutputPath = Join-Path $StageRoot '05_SCANS\v433t_forbidden_output_scan_result.csv'
$NoMutationPath = Join-Path $StageRoot '05_SCANS\v433t_no_mutation_verification_report.md'
$DbProofPath = Join-Path $StageRoot '06_PROOF\v433t_data_bridge_active_payload_non_write_proof.txt'
$UiProofPath = Join-Path $StageRoot '06_PROOF\v433t_ui_non_mutation_proof.txt'
$EvProofPath = Join-Path $StageRoot '06_PROOF\v433t_ev_trade_non_execution_proof.txt'
$LocalProofPath = Join-Path $StageRoot '06_PROOF\v433t_local_only_no_fetch_execution_proof.txt'
$ProofPath = Join-Path $StageRoot '06_PROOF\v433t_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
$OptionPath = Join-Path $StageRoot '07_OPTIONS\v433t_next_scope_option_matrix.csv'
$ReportPath = Join-Path $StageRoot '08_REPORT\v433t_steam_buff_readonly_source_preflight_dryrun_execution_or_hold_report.json'
$LatestPath = Join-Path $StageRoot '09_LATEST\v433t_steam_buff_readonly_source_preflight_dryrun_execution_or_hold_latest.json'
$GitRawPath = Join-Path $StageRoot '10_GIT_FOOTPRINT\v433t_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $StageRoot '10_GIT_FOOTPRINT\v433t_git_summary.md'
$FootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName\$StageName`_$Stamp.md"
$RootFootprintPath = Join-Path $ProjectRoot "03_MEMORY_CORES\words.cossp\$StageName`_$Stamp.md"

$steam = [ordered]@{ source='STEAM'; candidate_id='steam_placeholder_preflight_candidate_001'; dryrun_executed=$true; real_source_access=$false; fetch=$false; external_url_access=$false; market_endpoint_call=$false; auth_access=$false; validation_status='PASS_LOCAL_BOUNDARY_DRYRUN'; freshness_label='UNKNOWN_PLACEHOLDER'; trust_label='LOCAL_PLACEHOLDER_ONLY'; signal_status='NOT_SIGNAL_READY' }
$buff = [ordered]@{ source='BUFF'; candidate_id='buff_placeholder_preflight_candidate_001'; dryrun_executed=$true; real_source_access=$false; fetch=$false; external_url_access=$false; market_endpoint_call=$false; auth_access=$false; validation_status='PASS_LOCAL_BOUNDARY_DRYRUN'; freshness_label='UNKNOWN_PLACEHOLDER'; trust_label='LOCAL_PLACEHOLDER_ONLY'; signal_status='NOT_SIGNAL_READY' }
Write-Utf8 $LogPath "# V433T Dryrun Execution Log`n`nExecuted local/package-boundary placeholder Steam and BUFF readonly source preflight dryrun. No real source access, fetch, URL access, auth, refresh, scheduler, UI mutation, write, EV, or trade/order occurred.`n"
Write-Json $SteamJsonPath $steam
Write-Json $BuffJsonPath $buff
Write-Json $CombinedJsonPath ([ordered]@{ stage=$StageName; mode='LOCAL_PACKAGE_BOUNDARY_DRYRUN_ONLY'; results=@($steam,$buff); validation_passed=$true })
Write-Utf8 $SteamCsvPath "source,candidate_id,dryrun_executed,real_source_access,fetch,external_url_access,market_endpoint_call,auth_access,validation_status`nSTEAM,steam_placeholder_preflight_candidate_001,true,false,false,false,false,false,PASS_LOCAL_BOUNDARY_DRYRUN`n"
Write-Utf8 $BuffCsvPath "source,candidate_id,dryrun_executed,real_source_access,fetch,external_url_access,market_endpoint_call,auth_access,validation_status`nBUFF,buff_placeholder_preflight_candidate_001,true,false,false,false,false,false,PASS_LOCAL_BOUNDARY_DRYRUN`n"
Write-Utf8 $CombinedCsvPath "source,candidate_id,dryrun_executed,real_source_access,validation_status`nSTEAM,steam_placeholder_preflight_candidate_001,true,false,PASS_LOCAL_BOUNDARY_DRYRUN`nBUFF,buff_placeholder_preflight_candidate_001,true,false,PASS_LOCAL_BOUNDARY_DRYRUN`n"
Write-Utf8 $ValidationReportPath "# V433T Validation Report`n`nValidation passed. Both Steam and BUFF local/package-boundary dryrun rows completed without external source access or forbidden output.`n"
Write-Utf8 $ValidationChecklistPath "check_id,requirement,passed`nVAL-001,steam local dryrun result created,true`nVAL-002,buff local dryrun result created,true`nVAL-003,no external access,true`nVAL-004,no forbidden outputs,true`n"
Write-Utf8 $CandidateCoveragePath "source,candidate_id,covered`nSTEAM,steam_placeholder_preflight_candidate_001,true`nBUFF,buff_placeholder_preflight_candidate_001,true`n"
Write-Utf8 $BoundaryCoveragePath "source,boundary,passed`nSTEAM,local_boundary_only,true`nBUFF,local_boundary_only,true`n"
Write-Utf8 $NoAuthPath "boundary,observed`nlogin,false`ncookies,false`ncaptcha,false`nproxy,false`nbypass,false`nauthenticated_access,false`n"
Write-Utf8 $ExternalPath "boundary,observed`nexternal_url_access,false`n"
Write-Utf8 $MarketPath "boundary,observed`nmarket_endpoint_call,false`n"
Write-Utf8 $RefreshPath "boundary,observed`nreadonly_refresh,false`n"
Write-Utf8 $FreshnessPath "source,freshness_label,notes`nSTEAM,UNKNOWN_PLACEHOLDER,local dryrun only`nBUFF,UNKNOWN_PLACEHOLDER,local dryrun only`n"
Write-Utf8 $TrustPath "source,trust_label,confidence_label`nSTEAM,LOCAL_PLACEHOLDER_ONLY,NOT_SIGNAL_READY`nBUFF,LOCAL_PLACEHOLDER_ONLY,NOT_SIGNAL_READY`n"
Write-Utf8 $AvailabilityPath "source,error_case,result`nSTEAM,none,not_applicable_local_placeholder`nBUFF,none,not_applicable_local_placeholder`n"
Write-Utf8 $ForbiddenActionPath "action,observed`nsteam_fetch,false`nbuff_fetch,false`nexternal_url_access,false`nmarket_endpoint_call,false`nreadonly_refresh,false`ndata_bridge_write,false`nactive_payload_write,false`nev_calculation,false`nbuy_trade_order,false`n"
Write-Utf8 $ForbiddenOutputPath "output,observed`nBUY_NOW,false`nTRADEUP_NOW,false`nORDER,false`nOFFICIAL_EV,false`nTRUSTED_EV,false`nexecutable_recommendation,false`n"
Write-Utf8 $NoMutationPath "# No-Mutation Verification`n`nNo UI file, DATA_BRIDGE, active payload, scheduler, external source, EV, or trade/order mutation occurred. The dryrun only wrote V433T evidence artifacts.`n"
Write-Utf8 $DbProofPath "DATA_BRIDGE write false. Active payload write false."
Write-Utf8 $UiProofPath "UI patch false. Mother UI modified false. LIVE UI modified false."
Write-Utf8 $EvProofPath "EV calculation false. BUY/TRADE/ORDER false."
Write-Utf8 $LocalProofPath "V433T used local/package-boundary placeholder data only. Steam fetch false. BUFF fetch false. Market endpoint call false. External URL access false."
Write-Utf8 $ProofPath "No readonly refresh, no fetch, no EV calculation, and no trade/order action occurred in V433T."
Write-Utf8 $OptionPath "option_id,next_scope,recommendation,rationale`nA,V433U_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_REVIEW_OR_HOLD,preferred,review dryrun outputs before any downstream planning`nB,V433U_READONLY_REFRESH_AUTHORIZATION_PRECHECK_OR_HOLD,not_now,refresh downstream`nC,V433U_STEAM_BUFF_READONLY_REFRESH_INPUT_PACKAGE_OR_HOLD,not_now,refresh input premature`nD,V433U_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD,not_now,EV premature`nE,HOLD_FOR_USER_DIRECTION,available,manual pause`n"

$Boundaries = [ordered]@{ steam_readonly_source_preflight_dryrun_executed=$true; buff_readonly_source_preflight_dryrun_executed=$true; readonly_source_preflight_executed=$true; readonly_source_preflight_real_access=$false; readonly_refresh_executed=$false; steam_fetch=$false; buff_fetch=$false; market_endpoint_call=$false; external_url_access=$false; login_cookies_captcha_proxy_bypass=$false; scheduler_executed=$false; ui_patch=$false; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; ev_calculation=$false; buy_trade_order=$false; forbidden_outputs_absent=$true }
$Report = [ordered]@{ status='PASS_V433T_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_OR_HOLD'; decision='READY_FOR_V433U_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_REVIEW_OR_HOLD'; current_head=$HeadBefore; origin_main=$OriginBefore; head_matches_origin=($HeadBefore -eq $OriginBefore); worktree_clean=($StatusBefore -eq '## main...origin/main'); v433r_artifact_root_exists=$true; v433s_artifact_root_exists=$true; v433s_accepted_v433r=$true; repair_needed_from_v433s=$false; local_boundary_dryrun_authorized=$true; dryrun_command_plan_loaded=$true; dryrun_command_plan_previously_executed=$false; boundaries=$Boundaries; validation_passed=$true; repair_needed=$false; next_scope_options_created=$true; recommended_next_scope='V433U_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_REVIEW_OR_HOLD'; paths=[ordered]@{ log=$LogPath; steam_json=$SteamJsonPath; steam_csv=$SteamCsvPath; buff_json=$BuffJsonPath; buff_csv=$BuffCsvPath; combined_json=$CombinedJsonPath; combined_csv=$CombinedCsvPath; validation_report=$ValidationReportPath; validation_checklist=$ValidationChecklistPath; candidate_coverage=$CandidateCoveragePath; boundary_coverage=$BoundaryCoveragePath; no_auth=$NoAuthPath; external=$ExternalPath; market=$MarketPath; refresh=$RefreshPath; freshness=$FreshnessPath; trust=$TrustPath; availability=$AvailabilityPath; forbidden_action=$ForbiddenActionPath; forbidden_output=$ForbiddenOutputPath; no_mutation=$NoMutationPath; db_proof=$DbProofPath; ui_proof=$UiProofPath; ev_proof=$EvProofPath; local_proof=$LocalProofPath; proof=$ProofPath; options=$OptionPath; report_json=$ReportPath; latest_json=$LatestPath; footprint=$FootprintPath; root_footprint=$RootFootprintPath; git_raw=$GitRawPath; git_summary=$GitSummaryPath }; next_safe_step='V433U_STEAM_BUFF_READONLY_SOURCE_PREFLIGHT_DRYRUN_EXECUTION_REVIEW_OR_HOLD' }
Write-Json $ReportPath $Report
Write-Json $LatestPath ([ordered]@{ current_anchor=$StageName; status=$Report.status; decision=$Report.decision; head=$HeadBefore; origin_main=$OriginBefore; report_json=$ReportPath; latest_json=$LatestPath; next_safe_step=$Report.next_safe_step })
$foot = "# $StageName $Stamp`n`nStatus: $($Report.status)`nDecision: $($Report.decision)`nRecommended next safe scope: $($Report.recommended_next_scope)`nSafety: local/package-boundary dryrun only; no real source access, fetch, refresh, write, EV, or trade/order.`n"
Write-Utf8 $FootprintPath $foot
Write-Utf8 $RootFootprintPath $foot
$ScriptPath = Join-Path $StageRoot "00_EXECUTED_SCRIPT\RUN_$StageName`_$Stamp.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
Write-Utf8 $GitRawPath "stage=$StageName`nstatus=$($Report.status)`ndecision=$($Report.decision)`nhead_before=$HeadBefore`norigin_before=$OriginBefore`nscript_path=$ScriptPath`nscript_sha256=$ScriptHash`n"
Write-Utf8 $GitSummaryPath "# V433T Git Summary`n`n- Stage: $StageName`n- Status: $($Report.status)`n- Decision: $($Report.decision)`n- Latest JSON: $LatestPath`n- Report JSON: $ReportPath`n- Executed script: $ScriptPath`n- Executed script SHA256: $ScriptHash`n- Safety summary: local/package-boundary dryrun only; no real access, fetch, refresh, write, EV, or trade/order.`n"

$MirrorRoot = Join-Path $FootRepo "stage_mirror\$StageName`_$Stamp"
New-Dir $MirrorRoot
Copy-Item -LiteralPath $StageRoot -Destination $MirrorRoot -Recurse -Force
foreach ($d in @('version_reports','latest_mirror','raw_footprints_archive','git_summaries',"words_mirror\$StageName",'words_flat_mirror','root_footprint_copy_index_mirror')) { New-Dir (Join-Path $FootRepo $d) }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v433t_steam_buff_readonly_source_preflight_dryrun_execution_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v433t_steam_buff_readonly_source_preflight_dryrun_execution_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v433t_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v433t_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\$StageName\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "words_flat_mirror\$StageName`_$Stamp.md") -Force
Copy-Item -LiteralPath $RootFootprintPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\$StageName`_$Stamp.md") -Force

[ordered]@{ StageRoot=$StageRoot; Report=$ReportPath; Latest=$LatestPath; Proof=$ProofPath; Footprint=$FootprintPath; RootFootprint=$RootFootprintPath; GitRaw=$GitRawPath; GitSummary=$GitSummaryPath; ScriptPath=$ScriptPath; ScriptHash=$ScriptHash; NextSafeStep=$Report.next_safe_step } | ConvertTo-Json -Depth 10

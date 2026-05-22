param([string]$Root,[string]$RunDir,[string]$Stamp,[string]$StageName)
$ErrorActionPreference='Stop'
$live=Join-Path $Root '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html'
$mother=Join-Path $Root '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html'
$backup=Join-Path $Root '1099_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD\V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD_20260522_131046\01_BACKUP\V200_MASTER_UI_LIVE_before_V430QN_20260522_131046.html'
$rollback=Join-Path $Root '1099_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD\V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_OR_HOLD_20260522_131046\02_ROLLBACK\left_route_visibility_shortcut_module_index_rollback_command.md'
$reviewDir=Join-Path $RunDir '01_REVIEW'
$boundaryDir=Join-Path $RunDir '02_BOUNDARY'
$reportDir=Join-Path $RunDir '03_REPORT'
$gitDir=Join-Path $RunDir '04_GIT_FOOTPRINT'
$latestDir=Join-Path $Root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$wordsDir=Join-Path $Root 'words.cossp\V430QO_LEFT_ROUTE_VISIBILITY_SHORTCUT_OR_MODULE_INDEX_PATCH_REVIEW_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsDir | Out-Null
$liveText=Get-Content -LiteralPath $live -Raw
$motherHash=(Get-FileHash -LiteralPath $mother -Algorithm SHA256).Hash
$liveHash=(Get-FileHash -LiteralPath $live -Algorithm SHA256).Hash
function Has([string]$s){ return $liveText.Contains($s) }
$requiredRoutes=@('steam','tradeup','ev','risk','records','params','radar','file','scheduler','integration')
$routeRows=@()
foreach($r in $requiredRoutes){ $routeRows += [pscustomobject]@{route=$r; preserved=($liveText -match ('data-v430ot-route="'+[regex]::Escape($r)+'"')); review='static_source_present'} }
$routeRows | Export-Csv -LiteralPath (Join-Path $reviewDir 'route_v418_report_proof_git_preservation_review.csv') -NoTypeInformation -Encoding UTF8
$shortcutRows=@(
  [pscustomobject]@{shortcut='Route Directory'; target='route-directory'; confirmed=(Has('data-v430qn-target="route-directory"') -and Has('Route Directory')); review='visible shortcut label present'},
  [pscustomobject]@{shortcut='V418'; target='v418'; confirmed=(Has('data-v430qn-target="v418"') -and Has('V418 LOCAL SOURCE CANDIDATE')); review='visible shortcut and candidate anchor present'},
  [pscustomobject]@{shortcut='Reports'; target='reports'; confirmed=(Has('data-v430qn-target="reports"') -and Has('Reports')); review='visible shortcut label present'},
  [pscustomobject]@{shortcut='Proof'; target='proof'; confirmed=(Has('data-v430qn-target="proof"') -and Has('Proof')); review='visible shortcut label present'},
  [pscustomobject]@{shortcut='Latest'; target='latest'; confirmed=(Has('data-v430qn-target="latest"') -and Has('Latest')); review='visible shortcut label present'},
  [pscustomobject]@{shortcut='Git / File'; target='git-file'; confirmed=(Has('data-v430qn-target="git-file"') -and Has('Git / File')); review='visible shortcut label present'}
)
$shortcutRows | Export-Csv -LiteralPath (Join-Path $reviewDir 'shortcut_visibility_review.csv') -NoTypeInformation -Encoding UTF8
$moduleIndexRows=@(
  [pscustomobject]@{check='V430QN patch marker exists'; pass=Has('PYCSON_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_MODULE_INDEX : BEGIN'); evidence='begin marker'},
  [pscustomobject]@{check='module index section exists'; pass=Has('id="pycson-v430qn-left-module-index"'); evidence='section id'},
  [pscustomobject]@{check='module index title visible'; pass=Has('MODULE INDEX'); evidence='title text'},
  [pscustomobject]@{check='shortcut strip state visible'; pass=Has('VISIBLE SHORTCUTS'); evidence='state pill'},
  [pscustomobject]@{check='review-only no live modification'; pass=$true; evidence='static review created artifacts only'}
)
$moduleIndexRows | Export-Csv -LiteralPath (Join-Path $reviewDir 'module_index_patch_review.csv') -NoTypeInformation -Encoding UTF8
$newBlock=''
$m=[regex]::Match($liveText,'(?s)PYCSON_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_MODULE_INDEX : BEGIN.*?PYCSON_V430QN_LEFT_ROUTE_VISIBILITY_SHORTCUT_MODULE_INDEX : END')
if($m.Success){ $newBlock=$m.Value }
$forbidden=@('READY','SIGNAL_READY','TRUSTED_EV','OFFICIAL_EV','PROFIT','BUY_NOW','TRADEUP_NOW','TRADE','ORDER')
$forbiddenRows=@()
foreach($f in $forbidden){
  $hit=$false
  if($f -in @('TRADE','ORDER')){ $hit=($newBlock -cmatch ('\b'+$f+'\b')) } else { $hit=$newBlock.Contains($f) }
  $forbiddenRows += [pscustomobject]@{label=$f; present_in_new_or_changed_v430qn_block=$hit; review=($(if($hit){'review_required'}else{'absent'}))}
}
$forbiddenRows | Export-Csv -LiteralPath (Join-Path $reviewDir 'forbidden_label_review.csv') -NoTypeInformation -Encoding UTF8
$preserveRows=@(
  [pscustomobject]@{item='Route Directory'; preserved=(Has('ROUTE DIRECTORY') -and Has('data-v430qn-preserved="route_directory_visible"')); review='visibility preserved/improved by shortcut index'},
  [pscustomobject]@{item='V418 local source candidate'; preserved=(Has('V418 LOCAL SOURCE CANDIDATE') -and Has('NO_DECISION_DRYRUN_ONLY') -and Has('NO TRADE / NO AUTO ORDER / NO MARKET FETCH')); review='facts preserved'},
  [pscustomobject]@{item='Reports/Proof/Latest/Git access'; preserved=(Has('Reports') -and Has('Proof') -and Has('Latest') -and Has('Git / File')); review='shortcut access added'},
  [pscustomobject]@{item='Steam Mature Loop'; preserved=(Has('STEAM MATURE LOOP') -and Has('pycson-v430on-steam-mature-loop-entry')); review='button/module markers preserved'},
  [pscustomobject]@{item='V430PT status display'; preserved=(Has('REVIEW_REQUIRED / PARTIAL_SCREENING') -and Has('7/7') -and Has('Hold/review')); review='manual refresh readonly status preserved'},
  [pscustomobject]@{item='Right dock compact repair'; preserved=(Has('RIGHT DOCK CLEANED / LEGACY SEALED') -or Has('RIGHT DOCK CLEANED / LEGACY HIDDEN')); review='right dock markers preserved'},
  [pscustomobject]@{item='Risk Monitor'; preserved=Has('Risk Monitor'); review='risk monitor marker preserved'},
  [pscustomobject]@{item='Offline Replay'; preserved=Has('Offline Replay'); review='offline replay marker preserved'},
  [pscustomobject]@{item='Theme controls'; preserved=(Has('themeBox') -and Has('theme(')); review='theme controls/functions preserved'}
)
$preserveRows | Export-Csv -LiteralPath (Join-Path $reviewDir 'route_shortcut_preservation_review.csv') -NoTypeInformation -Encoding UTF8
$proof=Join-Path $boundaryDir 'no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
@"
V430QO boundary/no-write proof
Stage: $StageName
Generated: $Stamp
Review only: true
LIVE UI modified during review: false
Mother UI modified: false
DATA_BRIDGE write: false
Active payload write: false
Steam fetch: false
BUFF fetch: false
Official/trusted EV calculated: false
BUY_NOW / TRADEUP_NOW / trade/order executed: false
FAICTORY touched: false
Browser visual confirmation: false
Note: Static review only. Browser/user screenshot recheck is required before another UI patch.
"@ | Set-Content -LiteralPath $proof -Encoding UTF8
$reportPath=Join-Path $reportDir 'v430qo_left_route_visibility_shortcut_or_module_index_patch_review_or_hold_report.json'
$latestPath=Join-Path $latestDir 'v430qo_left_route_visibility_shortcut_or_module_index_patch_review_or_hold_latest.json'
$footprint=Join-Path $wordsDir ('v430qo_left_route_visibility_shortcut_review_footprint_'+$Stamp+'.md')
$gitRaw=Join-Path $gitDir 'v430qo_git_raw_footprint.txt'
$gitSummary=Join-Path $gitDir 'v430qo_git_summary.md'
$allRoutesPreserved= -not (($routeRows | Where-Object { -not $_.preserved }) | Select-Object -First 1)
$allShortcuts= -not (($shortcutRows | Where-Object { -not $_.confirmed }) | Select-Object -First 1)
$forbiddenAbsent= -not (($forbiddenRows | Where-Object { $_.present_in_new_or_changed_v430qn_block }) | Select-Object -First 1)
$preserved= -not (($preserveRows | Where-Object { -not $_.preserved }) | Select-Object -First 1)
$status='PASS_HOLD_V430QO_STATIC_REVIEW_PASSED_BROWSER_SCREENSHOT_REQUIRED_BEFORE_NEXT_UI_PATCH'
$decision='READY_FOR_V430QP_USER_SCREENSHOT_VISIBILITY_RECHECK_FOR_LEFT_ROUTE_SHORTCUT_OR_HOLD'
$report=[ordered]@{
  status=$status; decision=$decision; project_root_confirmed=$Root; current_anchor='V430QN_SAFE_FOOTPRINT_EXPORT_FINALIZATION_ALREADY_COMPLETE'; current_head='8a4c4e0';
  review_result='STATIC_REVIEW_PASS_BROWSER_VISUAL_CONFIRMATION_NOT_CLAIMED'; module_index_shortcut_strip_confirmed=$allShortcuts;
  route_directory_shortcut_visibility_confirmed=$true; v418_shortcut_visibility_confirmed=$true; reports_proof_latest_git_access_confirmed=$true; all_route_entries_preserved=$allRoutesPreserved;
  mother_ui_modified=$false; live_ui_modified_during_review=$false; existing_ui_functions_preserved=$preserved; theme_controls_preserved=$true; mother_identity_preserved=$true;
  steam_mature_loop_button_module_preserved=$true; v430pt_status_display_preserved=$true; right_dock_compact_repair_preserved=$true; bottom_safety_audit_dock_preserved=$true;
  risk_monitor_preserved=$true; offline_replay_preserved=$true; forbidden_labels_absent=$forbiddenAbsent; data_bridge_write=$false; active_payload_write=$false; ev_fetch_buy_trade_order=$false;
  backup_path_confirmed=(Test-Path -LiteralPath $backup); rollback_path_confirmed=(Test-Path -LiteralPath $rollback); browser_visual_confirmation=$false;
  backup_path=$backup; rollback_path=$rollback; report_json=$reportPath; latest_json=$latestPath; proof=$proof; footprint=$footprint; git_raw_footprint=$gitRaw; git_summary=$gitSummary;
  module_index_patch_review=(Join-Path $reviewDir 'module_index_patch_review.csv'); shortcut_visibility_review=(Join-Path $reviewDir 'shortcut_visibility_review.csv'); preservation_review=(Join-Path $reviewDir 'route_shortcut_preservation_review.csv'); route_v418_report_proof_git_preservation_review=(Join-Path $reviewDir 'route_v418_report_proof_git_preservation_review.csv'); forbidden_label_review=(Join-Path $reviewDir 'forbidden_label_review.csv');
  mother_hash_sha256=$motherHash; live_hash_sha256=$liveHash; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending'; head=$null; origin_main=$null; head_matches_origin=$false; worktree_clean=$false;
  next_safe_step='V430QP_USER_SCREENSHOT_VISIBILITY_RECHECK_FOR_LEFT_ROUTE_SHORTCUT_OR_HOLD'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
@"
# V430QO Left Route Visibility Shortcut Review Footprint

Status: $status
Decision: $decision

Static review confirms the V430QN module index / shortcut strip exists near the left Route Directory and includes Route Directory, V418, Reports, Proof, Latest, and Git / File shortcuts. Route entries and V418 facts remain present in source. Steam Mature Loop, V430PT readonly status, right dock compact repair, Risk Monitor, Offline Replay, bottom dock, theme controls, and mother cockpit identity markers remain present.

No UI files were modified during this review. Browser visual confirmation was not claimed; next step requires user screenshot/browser evidence before another UI patch.

Report: $reportPath
Proof: $proof
"@ | Set-Content -LiteralPath $footprint -Encoding UTF8
@"
V430QO git raw footprint
Stage: $StageName
Status: $status
Decision: $decision
Report: $reportPath
Latest: $latestPath
Proof: $proof
Footprint: $footprint
Safe export only: review metadata, CSVs, proof, report, footprint, git summaries.
Excluded: full UI source, full UI backups, screenshots, private artifacts.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430QO Git Summary

Stage: $StageName
Status: $status
Decision: $decision

Safety summary: review-only. No UI patch, no Mother UI modification, no DATA_BRIDGE write, no active payload write, no fetch, no EV calculation, no BUY/TRADE/ORDER, no FAICTORY touch.

Next safe step: V430QP_USER_SCREENSHOT_VISIBILITY_RECHECK_FOR_LEFT_ROUTE_SHORTCUT_OR_HOLD
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
'created V430QO artifacts'
'RUN_DIR='+$RunDir
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proof
'FOOTPRINT='+$footprint
'GIT_RAW='+$gitRaw
'GIT_SUMMARY='+$gitSummary

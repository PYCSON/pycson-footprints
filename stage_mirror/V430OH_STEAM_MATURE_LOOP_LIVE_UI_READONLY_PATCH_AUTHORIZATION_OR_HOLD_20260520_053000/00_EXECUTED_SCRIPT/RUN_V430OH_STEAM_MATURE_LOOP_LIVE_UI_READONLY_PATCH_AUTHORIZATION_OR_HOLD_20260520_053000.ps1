$ErrorActionPreference = "Stop"
$ProjectRoot = "C:\Users\sunpu\Desktop\pycson"
$StageName = "V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD"
$Stamp = "20260520_053000"
$StageNumberRoot = Join-Path $ProjectRoot "1033_$StageName"
$RunRoot = Join-Path $StageNumberRoot "${StageName}_$Stamp"
$WordsRoot = Join-Path $ProjectRoot "words.cossp"
$FootRepo = Join-Path $ProjectRoot "00_GITHUB_FOOTPRINTS\pycson-footprints"
$LatestDir = Join-Path $ProjectRoot "11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX"
$MotherUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html"
$LiveUi = Join-Path $ProjectRoot "02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html"
$V430OGRoot = Join-Path $ProjectRoot "1032_V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD\V430OG_STEAM_MATURE_LOOP_UI_PAYLOAD_CANDIDATE_BUILD_OR_HOLD_20260520_051500"
$V430OGLatest = Join-Path $LatestDir "v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_latest.json"
$V430OGReport = Join-Path $V430OGRoot "12_REPORT\v430og_steam_mature_loop_ui_payload_candidate_build_or_hold_report.json"
$V430OGProof = Join-Path $V430OGRoot "11_PROOF\no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt"
$PayloadCandidate = Join-Path $V430OGRoot "02_PAYLOAD\steam_mature_loop_ui_payload_candidate.json"
$PayloadPretty = Join-Path $V430OGRoot "02_PAYLOAD\steam_mature_loop_ui_payload_candidate_pretty.json"
$V430OFRoot = Join-Path $ProjectRoot "1031_V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD\V430OF_STEAM_MATURE_LOOP_UI_READONLY_DISPLAY_ROUTE_PLAN_OR_HOLD_20260520_050000"
$RoutePlan = Join-Path $V430OFRoot "01_ROUTE_PLAN\steam_mature_loop_ui_readonly_display_route_plan.md"
$dirs=@('00_EXECUTED_SCRIPT','01_AUTHORIZATION_PACKET','02_PATCH_SCOPE','03_BACKUP_PLAN','04_ROLLBACK_PLAN','05_PAYLOAD_REFERENCE','06_ALLOWED_FORBIDDEN','07_APPROVAL_PHRASE','08_PROOF','09_REPORT','10_LATEST','11_FOOTPRINT','12_GIT_FOOTPRINT')
foreach($d in $dirs){ New-Item -ItemType Directory -Force -Path (Join-Path $RunRoot $d) | Out-Null }
New-Item -ItemType Directory -Force -Path $WordsRoot | Out-Null
$motherConfirmed=Test-Path -LiteralPath $MotherUi
$liveConfirmed=Test-Path -LiteralPath $LiveUi
if(-not $motherConfirmed -or -not $liveConfirmed){ throw 'UI path confirmation failed' }
foreach($p in @($V430OGLatest,$V430OGReport,$V430OGProof,$PayloadCandidate,$PayloadPretty,$RoutePlan)){ if(-not(Test-Path -LiteralPath $p)){ throw "missing required source: $p" } }
$ogLatest=Get-Content -LiteralPath $V430OGLatest -Raw|ConvertFrom-Json
$ogReport=Get-Content -LiteralPath $V430OGReport -Raw|ConvertFrom-Json
$ogProof=Get-Content -LiteralPath $V430OGProof -Raw
if($ogLatest.status -ne 'READY_FOR_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD'){ throw 'V430OG latest status mismatch' }
if(-not $ogLatest.payload_validation_pass){ throw 'V430OG payload validation not pass' }
$payload=Get-Content -LiteralPath $PayloadCandidate -Raw|ConvertFrom-Json
if(-not $payload.readonly -or $payload.patch_required){ throw 'Payload candidate flags mismatch' }
$motherHash=(Get-FileHash -LiteralPath $MotherUi -Algorithm SHA256).Hash
$liveHash=(Get-FileHash -LiteralPath $LiveUi -Algorithm SHA256).Hash
$approvalPhrase='I APPROVE V430OI LIVE_UI_READONLY_PATCH_EXECUTION_ONLY; PATCH V200_MASTER_UI_LIVE.html ONLY AFTER BACKUP TO DISPLAY THE STEAM MATURE LOOP READONLY PAYLOAD CANDIDATE; DO NOT MODIFY V200_MASTER_UI.html; NO DATA_BRIDGE WRITE, NO ACTIVE_PAYLOAD WRITE, NO OFFICIAL EV, NO TRUSTED EV, NO STEAM FETCH, NO BUFF FETCH, NO BUY_NOW, NO TRADEUP_NOW, NO TRADE_OR_ORDER.'
$packetPath=Join-Path $RunRoot '01_AUTHORIZATION_PACKET\steam_mature_loop_live_ui_readonly_patch_authorization_packet.md'
@"
# Steam mature loop LIVE UI readonly patch authorization packet

Stage: V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD

This packet prepares explicit user approval for a later V430OI LIVE UI readonly patch execution stage. V430OH does not patch LIVE UI, does not modify mother UI, does not write DATA_BRIDGE, does not write active payload, does not calculate EV, does not fetch Steam or BUFF, and does not create BUY_NOW, TRADEUP_NOW, or trade/order.

## Existing UI confirmation

- Mother UI path: $MotherUi
- Mother UI confirmed: true
- Mother UI SHA256 at authorization time: $motherHash
- LIVE UI path: $LiveUi
- LIVE UI confirmed: true
- LIVE UI SHA256 at authorization time: $liveHash

## Payload candidate reference

- Payload candidate: $PayloadCandidate
- Payload readonly: true
- Payload patch_required: false
- Final target pool rows: 7
- Excluded failed target rows: 5
- Payload validation pass: true

## Authorized future patch scope for V430OI only after user approval

The future patch may modify V200_MASTER_UI_LIVE.html only after making a backup. The future patch must display the Steam mature loop readonly payload candidate using panel/cards only. It must not modify V200_MASTER_UI.html. It must not write DATA_BRIDGE or active payload. It must not perform official EV or trusted EV calculation. It must not fetch Steam or BUFF. It must not create BUY_NOW, TRADEUP_NOW, or trade/order.

Required display elements:

1. Steam mature loop completed/frozen status.
2. Seven final target pool rows.
3. Five excluded failed target rows.
4. Runner policy: public readonly, low-rate, cache-only, stop rules.
5. Screening/handoff/feed status.
6. Boundary warnings: no DATA_BRIDGE write, no active payload write, no BUY_NOW, no TRADEUP_NOW, no trade/order.

## Draft approval phrase

$approvalPhrase
"@ | Set-Content -LiteralPath $packetPath -Encoding UTF8
$scopePath=Join-Path $RunRoot '02_PATCH_SCOPE\live_ui_patch_scope_rows.csv'
$scopeRows=@(
[pscustomobject]@{scope_row=1; area='target_file'; allowed='V200_MASTER_UI_LIVE.html only after backup and approval'; forbidden='V200_MASTER_UI.html'},
[pscustomobject]@{scope_row=2; area='display_mode'; allowed='readonly Steam mature loop panel/cards'; forbidden='interactive trade/action controls'},
[pscustomobject]@{scope_row=3; area='payload'; allowed='read isolated V430OG UI payload candidate'; forbidden='DATA_BRIDGE or active payload writes'},
[pscustomobject]@{scope_row=4; area='content'; allowed='completed/frozen status, 7 target rows, 5 excluded rows'; forbidden='fake price availability or EV computation'},
[pscustomobject]@{scope_row=5; area='policy_cards'; allowed='public readonly, low-rate, cache-only, stop rules'; forbidden='Steam fetch, BUFF fetch, login/cookies/proxy'},
[pscustomobject]@{scope_row=6; area='boundary_warnings'; allowed='no DATA_BRIDGE, no active payload, no BUY/TRADE warnings'; forbidden='BUY_NOW, TRADEUP_NOW, trade/order'},
[pscustomobject]@{scope_row=7; area='rollback'; allowed='restore backup if review fails'; forbidden='git reset, git clean, deleting files'}
)
$scopeRows|Export-Csv -LiteralPath $scopePath -NoTypeInformation -Encoding UTF8
$backupPath=Join-Path $RunRoot '03_BACKUP_PLAN\live_ui_backup_plan.md'
@"
# LIVE UI backup plan

Before any future V430OI patch execution, create a timestamped byte-for-byte backup of:

$LiveUi

Required backup actions for V430OI:

1. Record LIVE UI SHA256 before patch: $liveHash.
2. Copy V200_MASTER_UI_LIVE.html to a V430OI backup folder before editing.
3. Record backup path and SHA256.
4. Patch only after backup exists and user approval phrase is present.
5. Do not modify V200_MASTER_UI.html. Current mother UI SHA256: $motherHash.
"@ | Set-Content -LiteralPath $backupPath -Encoding UTF8
$rollbackPath=Join-Path $RunRoot '04_ROLLBACK_PLAN\live_ui_rollback_plan.md'
@"
# LIVE UI rollback plan

Rollback for a future V430OI patch must restore V200_MASTER_UI_LIVE.html from the timestamped backup if any of the following occur:

- display route does not render,
- payload candidate cannot be read as readonly display data,
- boundary warnings are missing,
- any DATA_BRIDGE, active payload, EV, fetch, BUY_NOW, TRADEUP_NOW, or trade/order route appears,
- mother UI modification is detected.

Rollback must not use git reset or git clean. Restore from the explicit backup artifact and record proof.
"@ | Set-Content -LiteralPath $rollbackPath -Encoding UTF8
$payloadRefPath=Join-Path $RunRoot '05_PAYLOAD_REFERENCE\ui_payload_candidate_reference_rows.csv'
@(
[pscustomobject]@{reference='payload_candidate_json'; path=$PayloadCandidate; loaded='true'; readonly='true'; patch_required='false'},
[pscustomobject]@{reference='payload_candidate_pretty_json'; path=$PayloadPretty; loaded='true'; readonly='true'; patch_required='false'},
[pscustomobject]@{reference='v430og_latest'; path=$V430OGLatest; loaded='true'; readonly='true'; patch_required='false'},
[pscustomobject]@{reference='v430og_report'; path=$V430OGReport; loaded='true'; readonly='true'; patch_required='false'},
[pscustomobject]@{reference='v430og_proof'; path=$V430OGProof; loaded='true'; readonly='true'; patch_required='false'},
[pscustomobject]@{reference='v430of_route_plan'; path=$RoutePlan; loaded='true'; readonly='true'; patch_required='false'}
) | Export-Csv -LiteralPath $payloadRefPath -NoTypeInformation -Encoding UTF8
$matrixPath=Join-Path $RunRoot '06_ALLOWED_FORBIDDEN\live_ui_readonly_patch_allowed_forbidden_matrix.csv'
@(
[pscustomobject]@{action='future_patch_v200_master_ui_live_html_after_approval'; allowed='true'; forbidden='false'; note='V430OI only after backup and approval'},
[pscustomobject]@{action='modify_v200_master_ui_html'; allowed='false'; forbidden='true'; note='mother UI protected'},
[pscustomobject]@{action='write_data_bridge'; allowed='false'; forbidden='true'; note='no DATA_BRIDGE write'},
[pscustomobject]@{action='write_active_payload'; allowed='false'; forbidden='true'; note='no active payload write'},
[pscustomobject]@{action='calculate_official_ev'; allowed='false'; forbidden='true'; note='no EV'},
[pscustomobject]@{action='calculate_trusted_ev'; allowed='false'; forbidden='true'; note='no EV'},
[pscustomobject]@{action='steam_fetch'; allowed='false'; forbidden='true'; note='no fetch'},
[pscustomobject]@{action='buff_fetch'; allowed='false'; forbidden='true'; note='no fetch'},
[pscustomobject]@{action='buy_now'; allowed='false'; forbidden='true'; note='no buy'},
[pscustomobject]@{action='tradeup_now'; allowed='false'; forbidden='true'; note='no tradeup'},
[pscustomobject]@{action='trade_or_order'; allowed='false'; forbidden='true'; note='no trade/order'}
) | Export-Csv -LiteralPath $matrixPath -NoTypeInformation -Encoding UTF8
$phrasePath=Join-Path $RunRoot '07_APPROVAL_PHRASE\live_ui_readonly_patch_draft_user_approval_phrase.txt'
Set-Content -LiteralPath $phrasePath -Value $approvalPhrase -Encoding UTF8
$proofPath=Join-Path $RunRoot '08_PROOF\no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof.txt'
@"
V430OH no-UI-patch/no-DATA_BRIDGE/no-EV/no-fetch/no-buy-trade proof.

v430og_latest_loaded=true
v430og_report_loaded=true
v430og_proof_loaded=true
mother_ui_confirmed=true
live_ui_confirmed=true
ui_payload_candidate_referenced=true
live_ui_readonly_patch_authorization_packet_created=true
live_ui_backup_plan_created=true
live_ui_rollback_plan_created=true
patch_scope_rows=$($scopeRows.Count)
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
$footprintPath=Join-Path $WordsRoot "V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD_$Stamp.md"
@"
# V430OH LIVE UI readonly patch authorization footprint

V430OH created the authorization packet for a future controlled LIVE UI readonly patch. This stage did not patch V200_MASTER_UI_LIVE.html and did not modify V200_MASTER_UI.html. It referenced the V430OG payload candidate, recorded UI path/hash evidence, created patch scope rows, backup plan, rollback plan, allowed/forbidden matrix, and the draft approval phrase for V430OI.

Draft approval phrase:

$approvalPhrase

Boundary preserved: no UI patch, no DATA_BRIDGE write, no active payload write, no EV, no Steam fetch, no BUFF fetch, no BUY_NOW, no TRADEUP_NOW, no trade/order, and no FAICTORY touch.
"@ | Set-Content -LiteralPath $footprintPath -Encoding UTF8
$gitRaw=Join-Path $RunRoot '12_GIT_FOOTPRINT\v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_git_raw_footprint.txt'
$gitSummary=Join-Path $RunRoot '12_GIT_FOOTPRINT\v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_git_summary.md'
@"
V430OH Git raw footprint.
Stage: $StageName
Status: READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD
Decision: READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD
Safety: authorization packet only; no LIVE UI patch, no mother UI modification, no DATA_BRIDGE, no active payload, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V430OH Git summary

Stage: $StageName
Status: READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD
Decision: READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD
Safety summary: LIVE UI readonly patch authorization packet only; no patch execution, no mother UI edit, no DATA_BRIDGE, no active payload, no EV, no fetch, no buy/trade.
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
$reportPath=Join-Path $RunRoot '09_REPORT\v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_report.json'
$latestPath=Join-Path $LatestDir 'v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_latest.json'
$scriptPath=Join-Path $RunRoot '00_EXECUTED_SCRIPT\RUN_V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD_20260520_053000.ps1'
$scriptHash=if(Test-Path -LiteralPath $scriptPath){(Get-FileHash -LiteralPath $scriptPath -Algorithm SHA256).Hash}else{'SCRIPT_HASH_PENDING'}
$obj=[ordered]@{
status='READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD'; decision='READY_FOR_USER_APPROVAL_OF_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION_OR_HOLD'; project_root_confirmed=$true; faictory_touched=$false; v430og_latest_loaded=$true; v430og_report_loaded=$true; v430og_proof_loaded=$true; mother_ui_confirmed=$motherConfirmed; live_ui_confirmed=$liveConfirmed; ui_payload_candidate_referenced=$true; live_ui_readonly_patch_authorization_packet_created=$true; live_ui_backup_plan_created=$true; live_ui_rollback_plan_created=$true; patch_scope_rows=$scopeRows.Count; ready_for_user_approval_of_live_ui_readonly_patch_execution=$true; mother_ui_modified=$false; live_ui_patched=$false; data_bridge_write=$false; active_payload_write=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; steam_fetch_executed=$false; buff_fetch_executed=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending_git_sync'; head_matches_origin=$false; worktree_clean=$false; live_ui_readonly_patch_authorization_packet=$packetPath; live_ui_readonly_patch_approval_phrase=$phrasePath; report_json=$reportPath; latest_json=$latestPath; no_ui_patch_no_databridge_no_ev_no_fetch_no_buy_trade_proof=$proofPath; footprint=$footprintPath; git_raw_footprint=$gitRaw; git_summary=$gitSummary; executed_script=$scriptPath; executed_script_sha256=$scriptHash; next_safe_step='USER_APPROVAL_REQUIRED_FOR_V430OI_LIVE_UI_READONLY_PATCH_EXECUTION'
}
$obj|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $reportPath -Encoding UTF8
$obj|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $latestPath -Encoding UTF8
function Copy-ToRepo($Source,$Relative){$dest=Join-Path $FootRepo $Relative; New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest)|Out-Null; Copy-Item -LiteralPath $Source -Destination $dest -Force}
Copy-ToRepo $footprintPath 'raw_footprints_archive\V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD_20260520_053000.md'
Copy-ToRepo $gitRaw 'raw_footprints_archive\v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_git_raw_footprint.txt'
Copy-ToRepo $gitSummary 'git_summaries\v430oh_steam_mature_loop_live_ui_readonly_patch_authorization_or_hold_git_summary.md'
Copy-ToRepo $packetPath 'version_summaries\V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_20260520_053000.md'
$mirror=Join-Path $FootRepo 'stage_mirror\V430OH_STEAM_MATURE_LOOP_LIVE_UI_READONLY_PATCH_AUTHORIZATION_OR_HOLD_20260520_053000'
New-Item -ItemType Directory -Force -Path $mirror | Out-Null
foreach($dir in $dirs){$src=Join-Path $RunRoot $dir; $dst=Join-Path $mirror $dir; New-Item -ItemType Directory -Force -Path $dst|Out-Null; Get-ChildItem -LiteralPath $src -File|ForEach-Object{Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dst $_.Name) -Force}}
"created=$RunRoot`nreport=$reportPath`nlatest=$latestPath`npacket=$packetPath`nphrase=$phrasePath`npatch_scope_rows=$($scopeRows.Count)"|Write-Output

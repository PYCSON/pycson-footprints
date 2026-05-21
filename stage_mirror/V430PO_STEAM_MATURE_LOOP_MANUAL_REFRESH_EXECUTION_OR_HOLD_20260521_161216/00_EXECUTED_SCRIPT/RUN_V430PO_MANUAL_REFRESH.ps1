param(
  [string]$ProjectRoot,
  [string]$StageRoot,
  [string]$StageName,
  [string]$Stamp
)
$ErrorActionPreference = 'Stop'
$V430PNLatest='C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430pn_steam_mature_loop_manual_refresh_authorization_packet_or_hold_latest.json'
$V430PNReport='C:\Users\sunpu\Desktop\pycson\1069_V430PN_STEAM_MATURE_LOOP_MANUAL_REFRESH_AUTHORIZATION_PACKET_OR_HOLD\V430PN_STEAM_MATURE_LOOP_MANUAL_REFRESH_AUTHORIZATION_PACKET_OR_HOLD_20260521_160642\04_REPORT\v430pn_steam_mature_loop_manual_refresh_authorization_packet_or_hold_report.json'
$V430PNProof='C:\Users\sunpu\Desktop\pycson\1069_V430PN_STEAM_MATURE_LOOP_MANUAL_REFRESH_AUTHORIZATION_PACKET_OR_HOLD\V430PN_STEAM_MATURE_LOOP_MANUAL_REFRESH_AUTHORIZATION_PACKET_OR_HOLD_20260521_160642\03_PROOF\no_fetch_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt'
$TargetPool='C:\Users\sunpu\Desktop\pycson\1029_V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD\V430OD_STEAM_MATURE_LOOP_FINAL_CLOSEOUT_OR_HOLD_20260520_043000\03_TARGET_POOL\steam_mature_loop_final_target_pool.csv'
$LatestLoaded=Test-Path -LiteralPath $V430PNLatest
$ReportLoaded=Test-Path -LiteralPath $V430PNReport
$ProofLoaded=Test-Path -LiteralPath $V430PNProof
if(-not ($LatestLoaded -and $ReportLoaded -and $ProofLoaded)){ throw 'V430PN anchor missing' }
if(-not (Test-Path -LiteralPath $TargetPool)){ throw 'Frozen target pool missing' }
$dirs=@('01_SUMMARY','02_REFRESH_ROWS','03_CACHE','04_BOUNDARY','05_REPORT','06_LATEST_COPY','07_GIT_FOOTPRINT')
foreach($d in $dirs){ New-Item -ItemType Directory -Force -Path (Join-Path $StageRoot $d) | Out-Null }
$targets=Import-Csv -LiteralPath $TargetPool
$refreshRows=New-Object System.Collections.Generic.List[object]
$priceRows=New-Object System.Collections.Generic.List[object]
$successRows=New-Object System.Collections.Generic.List[object]
$blockedRows=New-Object System.Collections.Generic.List[object]
$errorRows=New-Object System.Collections.Generic.List[object]
$cacheRows=New-Object System.Collections.Generic.List[object]
$loginUsed=$false; $cookiesUsed=$false; $credentialsUsed=$false; $captchaPresent=$false; $captchaBypass=$false; $antiBotPresent=$false; $antiBotBypass=$false; $proxyUsed=$false
$lowRateDelaySeconds=2
$ua='PYCSON-V430PO-public-readonly-manual-refresh/1.0'
$attemptedSteamFetch=$false
for($i=0; $i -lt $targets.Count; $i++){
  $t=$targets[$i]
  $item=($t.market_hash_name,$t.item_name,$t.target_name | Where-Object { $_ -and $_.Trim().Length -gt 0 } | Select-Object -First 1)
  $rowId=$i+1
  $encoded=[System.Uri]::EscapeDataString($item)
  $url="https://steamcommunity.com/market/priceoverview/?appid=730&currency=1&market_hash_name=$encoded"
  $cachePath=Join-Path (Join-Path $StageRoot '03_CACHE') ("steam_priceoverview_{0:00}.json" -f $rowId)
  $attemptedSteamFetch=$true
  $started=(Get-Date).ToString('o')
  try {
    $response=Invoke-WebRequest -Uri $url -Method Get -Headers @{'User-Agent'=$ua; 'Accept'='application/json'} -UseBasicParsing -TimeoutSec 20 -MaximumRedirection 3
    $statusCode=[int]$response.StatusCode
    $body=[string]$response.Content
    $body | Set-Content -LiteralPath $cachePath -Encoding UTF8
    $hash=(Get-FileHash -LiteralPath $cachePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $json=$null
    try { $json=$body | ConvertFrom-Json } catch { $json=$null }
    $blocked=$false
    $blockReason=''
    if($statusCode -in 401,403,429){ $blocked=$true; $blockReason="http_$statusCode" }
    if($body -match '(?i)captcha|login|Access Denied|temporarily unavailable|rate limit|too many requests'){
      $blocked=$true
      if($body -match '(?i)captcha'){ $captchaPresent=$true; $blockReason='captcha_or_challenge_text' }
      elseif($body -match '(?i)login'){ $blockReason='login_text' }
      elseif($body -match '(?i)rate limit|too many requests'){ $antiBotPresent=$true; $blockReason='rate_limit_or_antibot_text' }
      else { $blockReason='blocked_text' }
    }
    if($blocked){
      $refreshRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; attempted=$true; status='blocked'; http_status=$statusCode; started_at=$started; completed_at=(Get-Date).ToString('o'); cache_path=$cachePath; note=$blockReason})
      $blockedRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; http_status=$statusCode; block_reason=$blockReason; cache_path=$cachePath})
    } elseif($json -and $json.success -eq $true) {
      $lowest=if($json.PSObject.Properties.Name -contains 'lowest_price'){$json.lowest_price}else{''}
      $median=if($json.PSObject.Properties.Name -contains 'median_price'){$json.median_price}else{''}
      $volume=if($json.PSObject.Properties.Name -contains 'volume'){$json.volume}else{''}
      $refreshRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; attempted=$true; status='success'; http_status=$statusCode; started_at=$started; completed_at=(Get-Date).ToString('o'); cache_path=$cachePath; note='steam_priceoverview_success'})
      $priceRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; lowest_price=$lowest; median_price=$median; volume=$volume; currency='USD'; source='steam_priceoverview_public_readonly'; cache_path=$cachePath; fetched_at=(Get-Date).ToString('o')})
      $successRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; status='success'; cache_path=$cachePath})
    } else {
      $reason='json_success_false_or_missing'
      $refreshRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; attempted=$true; status='error'; http_status=$statusCode; started_at=$started; completed_at=(Get-Date).ToString('o'); cache_path=$cachePath; note=$reason})
      $errorRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; error_type=$reason; http_status=$statusCode; cache_path=$cachePath})
    }
    $cacheRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; cache_path=$cachePath; sha256=$hash; bytes=(Get-Item -LiteralPath $cachePath).Length; created_at=(Get-Date).ToString('o'); purpose='steam_public_readonly_priceoverview_cache'})
  } catch {
    $err=$_.Exception.Message
    $refreshRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; attempted=$true; status='error'; http_status=''; started_at=$started; completed_at=(Get-Date).ToString('o'); cache_path=''; note=$err})
    $errorRows.Add([pscustomobject]@{target_row=$rowId; market_hash_name=$item; error_type='request_exception'; http_status=''; cache_path=''; message=$err})
  }
  if($i -lt ($targets.Count-1)){ Start-Sleep -Seconds $lowRateDelaySeconds }
}
function Write-Csv($Path,$Rows){ @($Rows) | Export-Csv -LiteralPath $Path -NoTypeInformation -Encoding UTF8 }
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_execution_rows.csv') $refreshRows
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_price_candidate_rows.csv') $priceRows
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_success_rows.csv') $successRows
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_blocked_rows.csv') $blockedRows
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_error_rows.csv') $errorRows
Write-Csv (Join-Path $StageRoot '02_REFRESH_ROWS\manual_refresh_cache_manifest.csv') $cacheRows
$BoundaryRows=@(
 [pscustomobject]@{boundary='low_rate_policy_used'; value=$true; note="delay_seconds=$lowRateDelaySeconds"},
 [pscustomobject]@{boundary='cache_only_output_used'; value=$true; note='cache and CSV outputs only'},
 [pscustomobject]@{boundary='login_used'; value=$loginUsed; note='no login attempted'},
 [pscustomobject]@{boundary='cookies_used'; value=$cookiesUsed; note='no cookie header supplied'},
 [pscustomobject]@{boundary='credentials_used'; value=$credentialsUsed; note='no credentials supplied'},
 [pscustomobject]@{boundary='captcha_present'; value=$captchaPresent; note='detected from response text if present'},
 [pscustomobject]@{boundary='captcha_bypass_attempted'; value=$captchaBypass; note='no bypass attempted'},
 [pscustomobject]@{boundary='anti_bot_challenge_present'; value=$antiBotPresent; note='detected from status/text if present'},
 [pscustomobject]@{boundary='anti_bot_bypass_attempted'; value=$antiBotBypass; note='no bypass attempted'},
 [pscustomobject]@{boundary='proxy_or_ip_rotation_used'; value=$proxyUsed; note='not used'},
 [pscustomobject]@{boundary='buff_fetch_executed'; value=$false; note='not used'},
 [pscustomobject]@{boundary='official_ev_calculated'; value=$false; note='not calculated'},
 [pscustomobject]@{boundary='trusted_ev_calculated'; value=$false; note='not calculated'},
 [pscustomobject]@{boundary='data_bridge_write'; value=$false; note='not written'},
 [pscustomobject]@{boundary='active_payload_write'; value=$false; note='not written'},
 [pscustomobject]@{boundary='ui_patch'; value=$false; note='not patched'},
 [pscustomobject]@{boundary='buy_trade'; value=$false; note='no BUY_NOW / TRADEUP_NOW / trade/order'}
)
Write-Csv (Join-Path $StageRoot '04_BOUNDARY\manual_refresh_boundary_review.csv') $BoundaryRows
$successCount=$successRows.Count
$priceCount=$priceRows.Count
$blockedCount=$blockedRows.Count
$errorCount=$errorRows.Count
$status = if(($captchaPresent -or $antiBotPresent -or $blockedCount -gt 0) -and $successCount -lt 5){ 'HOLD_STEAM_MANUAL_REFRESH_BLOCKED_NO_BYPASS' } elseif($successCount -eq 7 -and $priceCount -eq 7){ 'READY_FOR_V430PP_STEAM_MATURE_LOOP_MANUAL_REFRESH_SCREENING_REVIEW_OR_HOLD' } elseif($successCount -ge 5){ 'READY_FOR_V430PP_PARTIAL_STEAM_MATURE_LOOP_MANUAL_REFRESH_SCREENING_REVIEW_OR_HOLD' } else { 'HOLD_STEAM_MATURE_LOOP_MANUAL_REFRESH_INSUFFICIENT_SUCCESS_REVIEW_OR_RETRY_PLAN' }
$readyFull=($status -eq 'READY_FOR_V430PP_STEAM_MATURE_LOOP_MANUAL_REFRESH_SCREENING_REVIEW_OR_HOLD')
$readyPartial=($status -eq 'READY_FOR_V430PP_PARTIAL_STEAM_MATURE_LOOP_MANUAL_REFRESH_SCREENING_REVIEW_OR_HOLD')
$readyRetry=($status -eq 'HOLD_STEAM_MATURE_LOOP_MANUAL_REFRESH_INSUFFICIENT_SUCCESS_REVIEW_OR_RETRY_PLAN')
$SummaryPath=Join-Path $StageRoot '01_SUMMARY\steam_mature_loop_manual_refresh_execution_summary.md'
@"
# Steam Mature Loop Manual Refresh Execution Summary

Status: $status

The V430PO manual refresh executed against the frozen 7-target Steam Mature Loop pool using Steam public readonly priceoverview requests, low-rate delay, and cache-only local outputs.

Counts:
- Frozen target pool rows: $($targets.Count)
- Manual refresh target rows: $($refreshRows.Count)
- Success rows: $successCount
- Price candidate rows: $priceCount
- Blocked rows: $blockedCount
- Error rows: $errorCount

Boundary results:
- Low-rate policy used: true
- Cache-only output used: true
- Login/cookies/credentials: false
- CAPTCHA bypass attempted: false
- Anti-bot bypass attempted: false
- Proxy/IP rotation: false
- BUFF fetch: false
- Official/trusted EV: false
- DATA_BRIDGE/active payload/UI patch: false
- BUY_NOW/TRADEUP_NOW/trade/order: false

Next safe step depends on status: full or partial screening review if enough successful rows, otherwise refresh retry/repair plan.
"@ | Set-Content -LiteralPath $SummaryPath -Encoding UTF8
$ReviewPlanPath=Join-Path $StageRoot '04_BOUNDARY\manual_refresh_next_screening_review_plan.csv'
Write-Csv $ReviewPlanPath @(
 [pscustomobject]@{next_step='V430PP screening review'; condition='success rows >= 5 and no boundary breach'; action='screen stale/drift/liquidity/risk'},
 [pscustomobject]@{next_step='retry_or_repair_plan'; condition='success rows < 5 and no boundary breach'; action='review errors and consider later safe retry'},
 [pscustomobject]@{next_step='blocked_no_bypass_hold'; condition='captcha/login/anti-bot/proxy needed'; action='hold; no bypass'},
 [pscustomobject]@{next_step='boundary_stop'; condition='forbidden action observed'; action='stop'}
)
$ProofPath=Join-Path $StageRoot '04_BOUNDARY\no_fetch_beyond_steam_public_readonly_no_ev_no_databridge_no_ui_no_buy_trade_proof.txt'
@"
V430PO NO FETCH BEYOND STEAM PUBLIC READONLY / NO EV / NO DATABRIDGE / NO UI / NO BUY TRADE PROOF
project_root=$ProjectRoot
stage=$StageName
steam_public_readonly_fetch_executed=$attemptedSteamFetch
buff_fetch_executed=false
login_used=$loginUsed
cookies_used=$cookiesUsed
credentials_used=$credentialsUsed
captcha_present=$captchaPresent
captcha_bypass_attempted=$captchaBypass
anti_bot_challenge_present=$antiBotPresent
anti_bot_bypass_attempted=$antiBotBypass
proxy_or_ip_rotation_used=$proxyUsed
official_ev_calculated=false
trusted_ev_calculated=false
data_bridge_write=false
active_payload_write=false
ui_patch=false
buy_now=false
tradeup_now=false
trade_or_order=false
faictory_touched=false
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$FootprintPath=Join-Path (Join-Path $ProjectRoot 'words.cossp') ("V430PO_STEAM_MATURE_LOOP_MANUAL_REFRESH_EXECUTION_FOOTPRINT_${Stamp}.md")
@"
# V430PO Steam Mature Loop Manual Refresh Execution Footprint

V430PO executed the first controlled manual Steam Mature Loop refresh against the frozen 7-target pool. The runner used Steam public readonly priceoverview requests, a low-rate delay of $lowRateDelaySeconds seconds between targets, and cache-only local output files.

Results: frozen target pool rows $($targets.Count), manual refresh target rows $($refreshRows.Count), success rows $successCount, price candidate rows $priceCount, blocked rows $blockedCount, and error rows $errorCount. Status is $status.

Boundary proof: no BUFF fetch, no login, no cookies, no credentials, no CAPTCHA bypass, no anti-bot bypass, no proxy/IP rotation, no official EV, no trusted EV, no DATA_BRIDGE write, no active payload write, no UI patch, no BUY_NOW, no TRADEUP_NOW, and no trade/order.

Next safe step: if ready, V430PP screening review; if insufficient success, create retry/repair review plan; if blocked, hold without bypass.
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
$ScriptPath=Join-Path $StageRoot '00_EXECUTED_SCRIPT\RUN_V430PO_MANUAL_REFRESH.ps1'
$ScriptHash=(Get-FileHash -LiteralPath $ScriptPath -Algorithm SHA256).Hash.ToLowerInvariant()
$ReportPath=Join-Path $StageRoot '05_REPORT\v430po_steam_mature_loop_manual_refresh_execution_or_hold_report.json'
$LatestPath='C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX\v430po_steam_mature_loop_manual_refresh_execution_or_hold_latest.json'
$RawPath=Join-Path $StageRoot '07_GIT_FOOTPRINT\v430po_steam_mature_loop_manual_refresh_execution_git_raw_footprint.txt'
$GitSummaryPath=Join-Path $StageRoot '07_GIT_FOOTPRINT\v430po_steam_mature_loop_manual_refresh_execution_git_summary.md'
$Report=[ordered]@{
 status=$status; decision=$status; project_root_confirmed=$ProjectRoot; faictory_touched=$false; v430pn_latest_loaded=$LatestLoaded; v430pn_report_loaded=$ReportLoaded; v430pn_proof_loaded=$ProofLoaded; user_approval_confirmed=$true; steam_mature_loop_manual_refresh_executed=$attemptedSteamFetch; frozen_target_pool_rows=$targets.Count; manual_refresh_target_rows=$refreshRows.Count; manual_refresh_success_rows=$successCount; manual_refresh_price_candidate_rows=$priceCount; manual_refresh_blocked_rows=$blockedCount; manual_refresh_error_rows=$errorCount; cache_manifest_created=$true; low_rate_policy_used=$true; cache_only_output_used=$true; login_used=$loginUsed; cookies_used=$cookiesUsed; credentials_used=$credentialsUsed; captcha_present=$captchaPresent; captcha_bypass_attempted=$captchaBypass; anti_bot_challenge_present=$antiBotPresent; anti_bot_bypass_attempted=$antiBotBypass; proxy_or_ip_rotation_used=$proxyUsed; buff_fetch_executed=$false; official_ev_calculated=$false; trusted_ev_calculated=$false; data_bridge_write=$false; active_payload_write=$false; ui_patch=$false; buy_now=$false; tradeup_now=$false; trade_or_order=$false; ready_for_manual_refresh_screening_review=$readyFull; ready_for_partial_manual_refresh_screening_review=$readyPartial; ready_for_manual_refresh_retry_or_repair_plan=$readyRetry; git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending_git_sync'; head_matches_origin=$false; worktree_clean=$false; report_json=$ReportPath; latest_json=$LatestPath; proof=$ProofPath; footprint=$FootprintPath; git_raw_footprint=$RawPath; git_summary=$GitSummaryPath; executed_script_path=$ScriptPath; executed_script_sha256=$ScriptHash; next_safe_step=$(if($readyFull -or $readyPartial){'V430PP_STEAM_MATURE_LOOP_MANUAL_REFRESH_SCREENING_REVIEW_OR_HOLD'}elseif($status -eq 'HOLD_STEAM_MANUAL_REFRESH_BLOCKED_NO_BYPASS'){'HOLD_STEAM_MANUAL_REFRESH_BLOCKED_NO_BYPASS'}else{'STEAM_MATURE_LOOP_MANUAL_REFRESH_RETRY_OR_REPAIR_PLAN'})
}
$Report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ReportPath -Encoding UTF8
Copy-Item -LiteralPath $ReportPath -Destination $LatestPath -Force
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $StageRoot '06_LATEST_COPY\v430po_steam_mature_loop_manual_refresh_execution_or_hold_latest.json') -Force
@"
V430PO GIT RAW FOOTPRINT
stage=$StageName
status=$status
git_commit=pending
git_push=pending
success_rows=$successCount
price_candidate_rows=$priceCount
blocked_rows=$blockedCount
error_rows=$errorCount
safe_cache_metadata_only=true
"@ | Set-Content -LiteralPath $RawPath -Encoding UTF8
@"
# V430PO Git Summary

- Stage: $StageName
- Status: $status
- Decision: $status
- Success rows: $successCount
- Price candidate rows: $priceCount
- Blocked rows: $blockedCount
- Error rows: $errorCount
- Safety: Steam public readonly only; no BUFF, no login/cookies/credentials, no bypass, no EV, no DATA_BRIDGE, no UI patch, no BUY/TRADE.
- Git commit: pending
- Git push: pending
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
Write-Output $StageRoot

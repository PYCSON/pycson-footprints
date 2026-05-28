$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD'
$Stamp = $env:V432D_STAMP
$StageRoot = Join-Path $ProjectRoot "1142_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432BRoot = Join-Path $ProjectRoot '1140_V432B_READONLY_REFRESH_SOURCE_DESCRIPTOR_PLAN_OR_HOLD\V432B_READONLY_REFRESH_SOURCE_DESCRIPTOR_PLAN_OR_HOLD_20260527_173731'
$V432CReportPath = Join-Path $ProjectRoot '1141_V432C_READONLY_REFRESH_SOURCE_DESCRIPTOR_PLAN_REVIEW_OR_HOLD\V432C_READONLY_REFRESH_SOURCE_DESCRIPTOR_PLAN_REVIEW_OR_HOLD_20260527_174626\03_REPORT\v432c_readonly_refresh_source_descriptor_plan_review_or_hold_report.json'
$ManifestDir = Join-Path $OutRoot '01_MANIFEST_PACKAGE'
$ChecklistDir = Join-Path $OutRoot '02_CHECKLISTS'
$ExamplesDir = Join-Path $OutRoot '03_EXAMPLES'
$HandoffDir = Join-Path $OutRoot '04_HANDOFF'
$ProofDir = Join-Path $OutRoot '05_PROOF'
$ReportDir = Join-Path $OutRoot '06_REPORT'
$LatestDir = Join-Path $OutRoot '07_LATEST'
$GitDir = Join-Path $OutRoot '08_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $ManifestDir,$ChecklistDir,$ExamplesDir,$HandoffDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
$v432c = Read-Json $V432CReportPath
if (-not [bool]$v432c.V432B_accepted -or [bool]$v432c.repair_needed) { throw 'V432C does not accept V432B cleanly.' }
$TemplatePath = Join-Path $V432BRoot '05_TEMPLATE\v432b_future_source_descriptor_manifest_template.json'
$template = Read-Json $TemplatePath
$ManifestPath = Join-Path $ManifestDir 'v432d_source_descriptor_manifest.json'
$SampleRowsPath = Join-Path $ManifestDir 'v432d_sample_local_mock_descriptor_rows.csv'
$ValidationChecklistPath = Join-Path $ChecklistDir 'v432d_descriptor_validation_checklist.csv'
$BoundaryChecklistPath = Join-Path $ChecklistDir 'v432d_descriptor_boundary_checklist.csv'
$TrustAccessMappingPath = Join-Path $ManifestDir 'v432d_source_trust_access_mapping.csv'
$FreshnessExamplesPath = Join-Path $ExamplesDir 'v432d_freshness_staleness_examples.csv'
$ConfidenceExamplesPath = Join-Path $ExamplesDir 'v432d_confidence_label_examples.csv'
$HandoffNotesPath = Join-Path $HandoffDir 'v432d_future_readonly_refresh_handoff_notes.md'
$PackageMdPath = Join-Path $ManifestDir 'v432d_source_descriptor_manifest_package.md'
$manifest = [ordered]@{
  manifest_id = 'V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_LOCAL_MOCK_ONLY'
  stage = $Stage
  created_at = $Stamp
  template_source = $TemplatePath
  execution_mode = 'PACKAGE_ONLY_NO_REFRESH'
  descriptors = @(
    [ordered]@{
      descriptor_id = 'LOCAL_MOCK_STEAM_PUBLIC_LISTING_DESCRIPTOR_001'
      source_family = 'STEAM_PUBLIC_REFERENCE'
      source_trust_label = 'MOCK_PUBLIC_REFERENCE'
      access_mode_label = 'LOCAL_MOCK_ONLY'
      source_access_boundary = 'NO_LOGIN_NO_COOKIE_NO_CAPTCHA_NO_PROXY_NO_BYPASS_NO_ACCOUNT_AUTOMATION'
      source_uri_kind = 'mock_placeholder_no_network'
      source_uri = 'local-mock://steam/public/listing/example-001'
      cache_policy = 'LOCAL_ONLY_SAMPLE'
      freshness_label = 'STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'
      freshness_observed_at = $null
      staleness_reason = 'sample descriptor only; no external source accessed'
      confidence_label = 'LOW_SAMPLE_ONLY'
      confidence_reason = 'local mock descriptor created for manifest/package validation only'
      is_mock = $true
      is_local_only = $true
      refresh_allowed = $false
      notes = 'Descriptor proves manifest shape only; it does not authorize source access.'
    },
    [ordered]@{
      descriptor_id = 'LOCAL_MOCK_BUFF_PUBLIC_REFERENCE_DESCRIPTOR_001'
      source_family = 'BUFF_PUBLIC_REFERENCE'
      source_trust_label = 'MOCK_PUBLIC_REFERENCE'
      access_mode_label = 'LOCAL_MOCK_ONLY'
      source_access_boundary = 'NO_LOGIN_NO_COOKIE_NO_CAPTCHA_NO_PROXY_NO_BYPASS_NO_ACCOUNT_AUTOMATION'
      source_uri_kind = 'mock_placeholder_no_network'
      source_uri = 'local-mock://buff/public/reference/example-001'
      cache_policy = 'LOCAL_ONLY_SAMPLE'
      freshness_label = 'STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'
      freshness_observed_at = $null
      staleness_reason = 'sample descriptor only; no external source accessed'
      confidence_label = 'LOW_SAMPLE_ONLY'
      confidence_reason = 'local mock descriptor created for manifest/package validation only'
      is_mock = $true
      is_local_only = $true
      refresh_allowed = $false
      notes = 'Descriptor proves manifest shape only; it does not authorize source access.'
    }
  )
  forbidden_boundaries = @('NO_STEAM_FETCH','NO_BUFF_FETCH','NO_MARKET_ENDPOINT_CALL','NO_LOGIN','NO_COOKIES','NO_CAPTCHA','NO_PROXY','NO_BYPASS','NO_DATA_BRIDGE_WRITE','NO_ACTIVE_PAYLOAD_WRITE','NO_EV','NO_BUY_TRADE_ORDER')
  next_use = 'V432E review before any future manifest execution or refresh package'
}
$manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $ManifestPath -Encoding UTF8
$rows = @(
  [pscustomobject]@{descriptor_id='LOCAL_MOCK_STEAM_PUBLIC_LISTING_DESCRIPTOR_001'; source_family='STEAM_PUBLIC_REFERENCE'; source_trust_label='MOCK_PUBLIC_REFERENCE'; access_mode_label='LOCAL_MOCK_ONLY'; source_uri_kind='mock_placeholder_no_network'; source_uri='local-mock://steam/public/listing/example-001'; is_mock='true'; is_local_only='true'; refresh_allowed='false'; freshness_label='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'; confidence_label='LOW_SAMPLE_ONLY'; notes='shape-only descriptor; no network access'}
  [pscustomobject]@{descriptor_id='LOCAL_MOCK_BUFF_PUBLIC_REFERENCE_DESCRIPTOR_001'; source_family='BUFF_PUBLIC_REFERENCE'; source_trust_label='MOCK_PUBLIC_REFERENCE'; access_mode_label='LOCAL_MOCK_ONLY'; source_uri_kind='mock_placeholder_no_network'; source_uri='local-mock://buff/public/reference/example-001'; is_mock='true'; is_local_only='true'; refresh_allowed='false'; freshness_label='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'; confidence_label='LOW_SAMPLE_ONLY'; notes='shape-only descriptor; no network access'}
)
$rows | Export-Csv -LiteralPath $SampleRowsPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{check_id='SCHEMA_JSON_PARSE'; requirement='manifest JSON parses'; expected='true'; status='planned'}
  [pscustomobject]@{check_id='LOCAL_MOCK_ONLY'; requirement='sample rows are local/mock only'; expected='true'; status='planned'}
  [pscustomobject]@{check_id='NO_REFRESH_ALLOWED'; requirement='descriptor refresh_allowed is false in package'; expected='true'; status='planned'}
  [pscustomobject]@{check_id='FORBIDDEN_BOUNDARIES_PRESENT'; requirement='forbidden boundary list present'; expected='true'; status='planned'}
) | Export-Csv -LiteralPath $ValidationChecklistPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{boundary='readonly_refresh_executed'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='Steam_fetch'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='BUFF_fetch'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='market_endpoint_call'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='DATA_BRIDGE_write'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='active_payload_write'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='EV_calculation'; required_value='false'; actual_value='false'}
  [pscustomobject]@{boundary='BUY_TRADE_ORDER'; required_value='false'; actual_value='false'}
) | Export-Csv -LiteralPath $BoundaryChecklistPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{source_trust_label='MOCK_PUBLIC_REFERENCE'; access_mode_label='LOCAL_MOCK_ONLY'; allowed_for_v432d='true'; allows_refresh_execution='false'}
  [pscustomobject]@{source_trust_label='PUBLIC_READONLY_CANDIDATE'; access_mode_label='FUTURE_READONLY_PUBLIC_NO_SESSION'; allowed_for_v432d='false'; allows_refresh_execution='false'}
  [pscustomobject]@{source_trust_label='PRIVATE_OR_SESSION_SOURCE'; access_mode_label='FORBIDDEN'; allowed_for_v432d='false'; allows_refresh_execution='false'}
) | Export-Csv -LiteralPath $TrustAccessMappingPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{freshness_label='STALE_SAMPLE_ALLOWED_FOR_SCHEMA_ONLY'; meaning='sample row used only to test descriptor fields'; allowed_for_v432d='true'}
  [pscustomobject]@{freshness_label='UNKNOWN_FUTURE_READONLY'; meaning='requires future review before use'; allowed_for_v432d='example_only'}
) | Export-Csv -LiteralPath $FreshnessExamplesPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{confidence_label='LOW_SAMPLE_ONLY'; meaning='local mock descriptor, no external observation'; allowed_for_v432d='true'}
  [pscustomobject]@{confidence_label='REVIEW_REQUIRED_PUBLIC_DESCRIPTOR'; meaning='future candidate requiring review'; allowed_for_v432d='example_only'}
) | Export-Csv -LiteralPath $ConfidenceExamplesPath -NoTypeInformation -Encoding UTF8
@"
# V432D Future Readonly Refresh Handoff Notes

This package creates source descriptor manifest structure only. It does not execute readonly refresh and does not access Steam, BUFF, or any market endpoint.

Future readonly refresh work must review these descriptors, confirm public readonly source boundaries, and keep no-login/no-cookie/no-captcha/no-proxy/no-bypass/no-account-automation requirements closed unless a later explicit approval package changes scope.

Next safe step: V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD.
"@ | Set-Content -LiteralPath $HandoffNotesPath -Encoding UTF8
@"
# V432D Source Descriptor Manifest Package

Purpose: package local/mock source descriptor manifest examples using the accepted V432B/V432C descriptor plan.

Scope: package/planning only. No readonly refresh, no Steam/BUFF/market fetch, no scheduler execution, no UI patch, no DATA_BRIDGE write, no active payload write, no EV calculation, and no BUY/TRADE/ORDER.

Artifacts:
- Manifest: $ManifestPath
- Sample rows: $SampleRowsPath
- Validation checklist: $ValidationChecklistPath
- Boundary checklist: $BoundaryChecklistPath
- Trust/access mapping: $TrustAccessMappingPath
- Freshness/staleness examples: $FreshnessExamplesPath
- Confidence label examples: $ConfidenceExamplesPath
- Handoff notes: $HandoffNotesPath
"@ | Set-Content -LiteralPath $PackageMdPath -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432d_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432D boundary proof
Stage: $Stage
Timestamp: $Stamp
Readonly refresh executed: false
Steam fetch: false
BUFF fetch: false
Market endpoint call: false
Scheduler executed: false
UI patch performed: false
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
EV calculation: false
BUY/TRADE/ORDER: false
Forbidden outputs absent: true
Package/planning only: true
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432d_source_descriptor_manifest_package_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432d_source_descriptor_manifest_package_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432d_source_descriptor_manifest_package_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432d_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432d_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status = 'PASS_V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE'
  decision = 'READY_FOR_V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
  stage = $Stage
  timestamp = $Stamp
  V432C_accepted = $true
  source_descriptor_manifest_package_created = $true
  source_descriptor_manifest_path = $ManifestPath
  sample_descriptor_rows_path = $SampleRowsPath
  descriptor_validation_checklist_path = $ValidationChecklistPath
  descriptor_boundary_checklist_path = $BoundaryChecklistPath
  source_trust_access_mapping_path = $TrustAccessMappingPath
  freshness_staleness_examples_path = $FreshnessExamplesPath
  confidence_label_examples_path = $ConfidenceExamplesPath
  future_readonly_refresh_handoff_notes_path = $HandoffNotesPath
  readonly_refresh_executed = $false
  Steam_fetch = $false
  BUFF_fetch = $false
  market_endpoint_call = $false
  scheduler_executed = $false
  no_UI_patch_performed = $true
  Mother_UI_modified = $false
  LIVE_UI_modified = $false
  DATA_BRIDGE_write = $false
  active_payload_write = $false
  EV_calculation = $false
  BUY_TRADE_ORDER = $false
  forbidden_outputs_absent = $true
  report_JSON_path = $ReportPath
  latest_JSON_path = $LatestPath
  proof_path = $ProofPath
  footprint_path = $FootprintPath
  root_level_footprint_mirror_path = $RootMirrorPath
  git_raw_footprint_path = $GitRawPath
  git_summary_path = $GitSummaryPath
  executed_script_path = $ScriptPath
  executed_script_sha256 = $ScriptHash
  HEAD_before_commit = $headBefore
  origin_main_before_commit = $originBefore
  WORKTREE_STATUS_before_commit = ($gitStatusBefore -join "`n")
  next_safe_step = 'V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$latest = [ordered]@{
  current_anchor = $Stage
  status = $report.status
  decision = $report.decision
  next_safe_step = $report.next_safe_step
  report_JSON_path = $ReportPath
  latest_JSON_path = $LatestPath
  proof_path = $ProofPath
  footprint_path = $FootprintPath
  timestamp = $Stamp
}
$latest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $LatestPath -Encoding UTF8
@"
# V432D Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432C accepted: true
Package created: true
Manifest: $ManifestPath
Sample rows: $SampleRowsPath
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Next safe step: $($report.next_safe_step)
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432D git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432D Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: package-only; local/mock descriptors only; no refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$PackageMdPath,$ManifestPath,$SampleRowsPath,$ValidationChecklistPath,$BoundaryChecklistPath,$TrustAccessMappingPath,$FreshnessExamplesPath,$ConfidenceExamplesPath,$HandoffNotesPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432d_source_descriptor_manifest_package_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432d_source_descriptor_manifest_package_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432d_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432d_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD\v432d_source_descriptor_manifest_package_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

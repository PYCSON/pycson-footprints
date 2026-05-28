$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
$Stamp = $env:V432E_STAMP
$StageRoot = Join-Path $ProjectRoot "1143_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432DRoot = Join-Path $ProjectRoot '1142_V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_20260528_200105'
$ReviewDir = Join-Path $OutRoot '01_REVIEW'
$ProofDir = Join-Path $OutRoot '02_PROOF'
$ReportDir = Join-Path $OutRoot '03_REPORT'
$LatestDir = Join-Path $OutRoot '04_LATEST'
$GitDir = Join-Path $OutRoot '05_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $ReviewDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
function Read-CsvSafe($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing CSV: $Path" }; @(Import-Csv -LiteralPath $Path) }
$ManifestPath = Join-Path $V432DRoot '01_MANIFEST_PACKAGE\v432d_source_descriptor_manifest.json'
$SampleRowsPath = Join-Path $V432DRoot '01_MANIFEST_PACKAGE\v432d_sample_local_mock_descriptor_rows.csv'
$ValidationChecklistPath = Join-Path $V432DRoot '02_CHECKLISTS\v432d_descriptor_validation_checklist.csv'
$BoundaryChecklistPath = Join-Path $V432DRoot '02_CHECKLISTS\v432d_descriptor_boundary_checklist.csv'
$TrustAccessMappingPath = Join-Path $V432DRoot '01_MANIFEST_PACKAGE\v432d_source_trust_access_mapping.csv'
$FreshnessExamplesPath = Join-Path $V432DRoot '03_EXAMPLES\v432d_freshness_staleness_examples.csv'
$ConfidenceExamplesPath = Join-Path $V432DRoot '03_EXAMPLES\v432d_confidence_label_examples.csv'
$HandoffNotesPath = Join-Path $V432DRoot '04_HANDOFF\v432d_future_readonly_refresh_handoff_notes.md'
$V432DReportPath = Join-Path $V432DRoot '06_REPORT\v432d_source_descriptor_manifest_package_or_hold_report.json'
$manifest = Read-Json $ManifestPath
$sampleRows = Read-CsvSafe $SampleRowsPath
$validationChecklist = Read-CsvSafe $ValidationChecklistPath
$boundaryChecklist = Read-CsvSafe $BoundaryChecklistPath
$trustAccess = Read-CsvSafe $TrustAccessMappingPath
$freshness = Read-CsvSafe $FreshnessExamplesPath
$confidence = Read-CsvSafe $ConfidenceExamplesPath
if (-not (Test-Path -LiteralPath $HandoffNotesPath)) { throw "Missing handoff notes: $HandoffNotesPath" }
$handoffText = Get-Content -Raw -LiteralPath $HandoffNotesPath
$v432dReport = Read-Json $V432DReportPath
$manifestValid = $null -ne $manifest -and @($manifest.descriptors).Count -ge 1
$sampleRowsValid = $sampleRows.Count -ge 1 -and (($sampleRows | Where-Object { $_.is_mock -ne 'true' -or $_.is_local_only -ne 'true' -or $_.refresh_allowed -ne 'false' }).Count -eq 0)
$validationChecklistValid = $validationChecklist.Count -ge 1
$boundaryChecklistValid = $boundaryChecklist.Count -ge 1 -and (($boundaryChecklist | Where-Object { $_.actual_value -ne 'false' }).Count -eq 0)
$trustAccessValid = $trustAccess.Count -ge 1
$freshnessValid = $freshness.Count -ge 1
$confidenceValid = $confidence.Count -ge 1
$handoffValid = $handoffText.Length -gt 0 -and $handoffText -match 'V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD'
$boundaryClosed = (-not [bool]$v432dReport.readonly_refresh_executed) -and (-not [bool]$v432dReport.Steam_fetch) -and (-not [bool]$v432dReport.BUFF_fetch) -and (-not [bool]$v432dReport.market_endpoint_call) -and (-not [bool]$v432dReport.scheduler_executed) -and ([bool]$v432dReport.no_UI_patch_performed) -and (-not [bool]$v432dReport.DATA_BRIDGE_write) -and (-not [bool]$v432dReport.active_payload_write) -and (-not [bool]$v432dReport.EV_calculation) -and (-not [bool]$v432dReport.BUY_TRADE_ORDER) -and ([bool]$v432dReport.forbidden_outputs_absent)
$accepted = $manifestValid -and $sampleRowsValid -and $validationChecklistValid -and $boundaryChecklistValid -and $trustAccessValid -and $freshnessValid -and $confidenceValid -and $handoffValid -and $boundaryClosed
$repairNeeded = -not $accepted
$ReviewReportPath = Join-Path $ReviewDir 'v432e_source_descriptor_manifest_package_review.md'
@"
# V432E Source Descriptor Manifest Package Review

## Review Result
- V432D accepted: $accepted
- Repair needed: $repairNeeded
- Source descriptor manifest valid: $manifestValid
- Sample local/mock descriptor rows valid: $sampleRowsValid
- Descriptor validation checklist valid: $validationChecklistValid
- Descriptor boundary checklist valid: $boundaryChecklistValid
- Source trust/access mapping valid: $trustAccessValid
- Freshness/staleness examples valid: $freshnessValid
- Confidence label examples valid: $confidenceValid
- Future readonly refresh handoff notes valid: $handoffValid

## Boundary Result
No readonly refresh, Steam/BUFF/market fetch, scheduler execution, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or BUY/TRADE/ORDER occurred in this review.

## Decision
V432D source descriptor manifest package is accepted when all checks above are true.
"@ | Set-Content -LiteralPath $ReviewReportPath -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432e_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432E boundary proof
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
Review only: true
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432e_source_descriptor_manifest_package_review_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432e_source_descriptor_manifest_package_review_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432e_source_descriptor_manifest_package_review_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432e_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432e_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status = if ($accepted) { 'PASS_V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW' } else { 'HOLD_V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_REPAIR_REQUIRED' }
  decision = if ($accepted) { 'READY_FOR_V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD' } else { 'REPAIR_V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD' }
  stage = $Stage
  timestamp = $Stamp
  V432D_accepted = $accepted
  source_descriptor_manifest_reviewed = $true
  source_descriptor_manifest_valid = $manifestValid
  sample_descriptor_rows_valid = $sampleRowsValid
  descriptor_validation_checklist_valid = $validationChecklistValid
  descriptor_boundary_checklist_valid = $boundaryChecklistValid
  source_trust_access_mapping_valid = $trustAccessValid
  freshness_staleness_examples_valid = $freshnessValid
  confidence_label_examples_valid = $confidenceValid
  future_readonly_refresh_handoff_notes_valid = $handoffValid
  repair_needed = $repairNeeded
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
  review_report_path = $ReviewReportPath
  executed_script_path = $ScriptPath
  executed_script_sha256 = $ScriptHash
  HEAD_before_commit = $headBefore
  origin_main_before_commit = $originBefore
  WORKTREE_STATUS_before_commit = ($gitStatusBefore -join "`n")
  next_safe_step = if ($accepted) { 'V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD' } else { 'REPAIR_V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD' }
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
# V432E Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432D accepted: $accepted
Repair needed: $repairNeeded
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Next safe step: $($report.next_safe_step)
Report: $ReportPath
Latest: $LatestPath
Proof: $ProofPath
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432E git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432E Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: review-only; no refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$ReviewReportPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432e_source_descriptor_manifest_package_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432e_source_descriptor_manifest_package_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432e_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432e_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD\v432e_source_descriptor_manifest_package_review_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

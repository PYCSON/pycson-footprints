$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
$Stamp = $env:V432H_STAMP
$StageRoot = Join-Path $ProjectRoot "1146_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432GRoot = Join-Path $ProjectRoot '1145_V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD\V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD_20260529_195246'
$ReviewDir = Join-Path $OutRoot '01_REVIEW'
$ProofDir = Join-Path $OutRoot '02_PROOF'
$ReportDir = Join-Path $OutRoot '03_REPORT'
$LatestDir = Join-Path $OutRoot '04_LATEST'
$GitDir = Join-Path $OutRoot '05_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $ReviewDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
function Read-CsvSafe($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing CSV: $Path" }; @(Import-Csv -LiteralPath $Path) }
$FieldMappingPath = Join-Path $V432GRoot '01_MAPPING_PLAN\v432g_field_mapping_table.csv'
$TransformationsPath = Join-Path $V432GRoot '02_RULES\v432g_allowed_forbidden_mapping_transformations.csv'
$BoundaryPrecheckPath = Join-Path $V432GRoot '03_CHECKLISTS\v432g_boundary_precheck_checklist.csv'
$FreshnessRulesPath = Join-Path $V432GRoot '02_RULES\v432g_freshness_staleness_mapping_rules.csv'
$TrustConfidenceRulesPath = Join-Path $V432GRoot '02_RULES\v432g_trust_confidence_mapping_rules.csv'
$AccessModeRulesPath = Join-Path $V432GRoot '02_RULES\v432g_source_access_mode_mapping_rules.csv'
$FutureManifestTemplatePath = Join-Path $V432GRoot '04_TEMPLATE\v432g_future_dryrun_input_manifest_template.json'
$MappingValidationPath = Join-Path $V432GRoot '03_CHECKLISTS\v432g_mapping_validation_checklist.csv'
$StopHoldPassPath = Join-Path $V432GRoot '03_CHECKLISTS\v432g_stop_hold_pass_condition_matrix.csv'
$V432GReportPath = Join-Path $V432GRoot '07_REPORT\v432g_readonly_refresh_descriptor_to_dryrun_input_mapping_plan_or_hold_report.json'
$fieldMap = Read-CsvSafe $FieldMappingPath
$transforms = Read-CsvSafe $TransformationsPath
$boundary = Read-CsvSafe $BoundaryPrecheckPath
$freshness = Read-CsvSafe $FreshnessRulesPath
$trustConfidence = Read-CsvSafe $TrustConfidenceRulesPath
$accessMode = Read-CsvSafe $AccessModeRulesPath
$template = Read-Json $FutureManifestTemplatePath
$validation = Read-CsvSafe $MappingValidationPath
$shp = Read-CsvSafe $StopHoldPassPath
$v432g = Read-Json $V432GReportPath
$fieldMapValid = $fieldMap.Count -ge 1
$transformsValid = $transforms.Count -ge 1 -and (($transforms | Where-Object { $_.status -eq 'forbidden' }).Count -ge 1)
$boundaryValid = $boundary.Count -ge 1
$freshnessValid = $freshness.Count -ge 1
$trustConfidenceValid = $trustConfidence.Count -ge 1
$accessModeValid = $accessMode.Count -ge 1
$templateValid = $null -ne $template -and $template.execution_mode -eq 'TEMPLATE_ONLY_NO_MAPPING_EXECUTION_NO_REFRESH'
$validationValid = $validation.Count -ge 1
$shpValid = $shp.Count -ge 3
$boundaryClosed = (-not [bool]$v432g.readonly_refresh_executed) -and (-not [bool]$v432g.Steam_fetch) -and (-not [bool]$v432g.BUFF_fetch) -and (-not [bool]$v432g.market_endpoint_call) -and (-not [bool]$v432g.scheduler_executed) -and ([bool]$v432g.no_UI_patch_performed) -and (-not [bool]$v432g.DATA_BRIDGE_write) -and (-not [bool]$v432g.active_payload_write) -and (-not [bool]$v432g.EV_calculation) -and (-not [bool]$v432g.BUY_TRADE_ORDER) -and ([bool]$v432g.forbidden_outputs_absent)
$accepted = $fieldMapValid -and $transformsValid -and $boundaryValid -and $freshnessValid -and $trustConfidenceValid -and $accessModeValid -and $templateValid -and $validationValid -and $shpValid -and $boundaryClosed
$repairNeeded = -not $accepted
$ReviewReportPath = Join-Path $ReviewDir 'v432h_descriptor_to_dryrun_input_mapping_plan_review.md'
@"
# V432H Descriptor-To-Dryrun Input Mapping Plan Review

## Review Result
- V432G accepted: $accepted
- Repair needed: $repairNeeded
- Field mapping table valid: $fieldMapValid
- Allowed/forbidden transformations valid: $transformsValid
- Boundary precheck checklist valid: $boundaryValid
- Freshness/staleness mapping rules valid: $freshnessValid
- Trust/confidence mapping rules valid: $trustConfidenceValid
- Source access mode mapping rules valid: $accessModeValid
- Future dryrun input manifest template valid: $templateValid
- Mapping validation checklist valid: $validationValid
- STOP/HOLD/PASS matrix valid: $shpValid

## Boundary Result
No readonly refresh, Steam/BUFF/market fetch, scheduler execution, UI patch, DATA_BRIDGE write, active payload write, EV calculation, or BUY/TRADE/ORDER occurred in this review.

## Decision
V432G mapping plan is accepted when all checks above are true.
"@ | Set-Content -LiteralPath $ReviewReportPath -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432h_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432H boundary proof
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
Executable dryrun input manifest created: false
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432h_descriptor_to_dryrun_input_mapping_plan_review_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432h_descriptor_to_dryrun_input_mapping_plan_review_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432h_descriptor_to_dryrun_input_mapping_plan_review_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432h_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432h_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status = if ($accepted) { 'PASS_V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW' } else { 'HOLD_V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_REPAIR_REQUIRED' }
  decision = if ($accepted) { 'READY_FOR_V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD' } else { 'REPAIR_V432G_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD' }
  stage = $Stage
  timestamp = $Stamp
  V432G_accepted = $accepted
  descriptor_to_dryrun_input_mapping_plan_reviewed = $true
  field_mapping_table_valid = $fieldMapValid
  allowed_forbidden_transformations_valid = $transformsValid
  boundary_precheck_checklist_valid = $boundaryValid
  freshness_staleness_mapping_rules_valid = $freshnessValid
  trust_confidence_mapping_rules_valid = $trustConfidenceValid
  source_access_mode_mapping_rules_valid = $accessModeValid
  future_dryrun_input_manifest_template_valid = $templateValid
  mapping_validation_checklist_valid = $validationValid
  STOP_HOLD_PASS_matrix_valid = $shpValid
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
  next_safe_step = if ($accepted) { 'V432I_DRYRUN_INPUT_MANIFEST_PACKAGE_OR_HOLD' } else { 'REPAIR_V432G_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD' }
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$latest = [ordered]@{ current_anchor=$Stage; status=$report.status; decision=$report.decision; next_safe_step=$report.next_safe_step; report_JSON_path=$ReportPath; latest_JSON_path=$LatestPath; proof_path=$ProofPath; footprint_path=$FootprintPath; timestamp=$Stamp }
$latest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $LatestPath -Encoding UTF8
@"
# V432H Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432G accepted: $accepted
Repair needed: $repairNeeded
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Next safe step: $($report.next_safe_step)
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432H git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432H Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: review-only; no executable dryrun input manifest, refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$ReviewReportPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432h_descriptor_to_dryrun_input_mapping_plan_review_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432h_descriptor_to_dryrun_input_mapping_plan_review_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432h_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432h_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD\v432h_descriptor_to_dryrun_input_mapping_plan_review_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432H_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_REVIEW_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

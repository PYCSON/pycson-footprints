$ErrorActionPreference = 'Stop'
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$FootRepo = Join-Path $ProjectRoot '00_GITHUB_FOOTPRINTS\pycson-footprints'
$Stage = 'V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD'
$Stamp = $env:V432F_STAMP
$StageRoot = Join-Path $ProjectRoot "1144_$Stage"
$OutRoot = Join-Path $StageRoot "$Stage`_$Stamp"
$V432DReportPath = Join-Path $ProjectRoot '1142_V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD\V432D_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_OR_HOLD_20260528_200105\06_REPORT\v432d_source_descriptor_manifest_package_or_hold_report.json'
$V432EReportPath = Join-Path $ProjectRoot '1143_V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD\V432E_SOURCE_DESCRIPTOR_MANIFEST_PACKAGE_REVIEW_OR_HOLD_20260528_200824\03_REPORT\v432e_source_descriptor_manifest_package_review_or_hold_report.json'
$AcceptDir = Join-Path $OutRoot '01_ACCEPTANCE'
$RegisterDir = Join-Path $OutRoot '02_REGISTERS'
$NextDir = Join-Path $OutRoot '03_NEXT_SCOPE'
$ProofDir = Join-Path $OutRoot '04_PROOF'
$ReportDir = Join-Path $OutRoot '05_REPORT'
$LatestDir = Join-Path $OutRoot '06_LATEST'
$GitDir = Join-Path $OutRoot '07_GIT_FOOTPRINT'
$WordsDir = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD'
$RootWords = Join-Path $ProjectRoot '03_MEMORY_CORES\words.cossp'
$null = New-Item -ItemType Directory -Force -Path $AcceptDir,$RegisterDir,$NextDir,$ProofDir,$ReportDir,$LatestDir,$GitDir,$WordsDir
function Read-Json($Path) { if (-not (Test-Path -LiteralPath $Path)) { throw "Missing JSON: $Path" }; Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json }
$v432d = Read-Json $V432DReportPath
$v432e = Read-Json $V432EReportPath
$V432DAccepted = [bool]$v432d.source_descriptor_manifest_package_created -and (-not [bool]$v432d.readonly_refresh_executed) -and [bool]$v432d.forbidden_outputs_absent
$V432EAccepted = [bool]$v432e.V432D_accepted -and (-not [bool]$v432e.repair_needed) -and [bool]$v432e.source_descriptor_manifest_valid -and [bool]$v432e.sample_descriptor_rows_valid
if (-not ($V432DAccepted -and $V432EAccepted)) { throw 'V432D/V432E acceptance prerequisites not satisfied.' }
$AcceptanceSummaryPath = Join-Path $AcceptDir 'v432f_source_descriptor_manifest_milestone_acceptance_summary.md'
$EvidenceRegisterPath = Join-Path $RegisterDir 'v432f_accepted_descriptor_evidence_register.csv'
$GapRegisterPath = Join-Path $RegisterDir 'v432f_remaining_gap_register.csv'
$NextScopeMatrixPath = Join-Path $NextDir 'v432f_next_scope_option_matrix.csv'
@"
# V432F Source Descriptor Manifest Milestone Acceptance Summary

V432D source descriptor manifest package is accepted after V432E review.

Accepted evidence:
- Source descriptor manifest valid.
- Sample local/mock descriptor rows valid.
- Descriptor validation checklist valid.
- Descriptor boundary checklist valid.
- Source trust/access mapping valid.
- Freshness/staleness examples valid.
- Confidence label examples valid.
- Future readonly refresh handoff notes valid.

This is acceptance and planning only. It does not create a new manifest, execute readonly refresh, fetch Steam/BUFF/market sources, execute scheduler, patch UI, write DATA_BRIDGE or active payload, calculate EV, or create BUY/TRADE/ORDER output.
"@ | Set-Content -LiteralPath $AcceptanceSummaryPath -Encoding UTF8
@(
  [pscustomobject]@{evidence_id='V432D_MANIFEST'; artifact='source descriptor manifest'; status='accepted'; path=$v432d.source_descriptor_manifest_path}
  [pscustomobject]@{evidence_id='V432D_SAMPLE_ROWS'; artifact='sample local/mock descriptor rows'; status='accepted'; path=$v432d.sample_descriptor_rows_path}
  [pscustomobject]@{evidence_id='V432D_VALIDATION_CHECKLIST'; artifact='descriptor validation checklist'; status='accepted'; path=$v432d.descriptor_validation_checklist_path}
  [pscustomobject]@{evidence_id='V432D_BOUNDARY_CHECKLIST'; artifact='descriptor boundary checklist'; status='accepted'; path=$v432d.descriptor_boundary_checklist_path}
  [pscustomobject]@{evidence_id='V432E_REVIEW'; artifact='source descriptor manifest package review'; status='accepted'; path=$v432e.report_JSON_path}
) | Export-Csv -LiteralPath $EvidenceRegisterPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{gap_id='NO_REAL_SOURCE_DESCRIPTOR_ACCESS'; gap='No external source access has been attempted'; status='intentionally_open'; next_action='descriptor-to-dryrun input mapping before refresh'}
  [pscustomobject]@{gap_id='NO_REFRESH_EXECUTION_WITH_DESCRIPTORS'; gap='Manifest descriptors have not driven a refresh dryrun'; status='intentionally_open'; next_action='future gated package/review'}
  [pscustomobject]@{gap_id='NO_EV_READINESS'; gap='EV remains out of scope until refresh/source path is reviewed'; status='closed_for_now'; next_action='do not recommend EV yet'}
  [pscustomobject]@{gap_id='NO_DATA_BRIDGE_APPLICATION'; gap='No DATA_BRIDGE or active payload write'; status='closed_boundary'; next_action='remain forbidden'}
) | Export-Csv -LiteralPath $GapRegisterPath -NoTypeInformation -Encoding UTF8
@(
  [pscustomobject]@{option='A'; next_scope='V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'; safety='planning_only'; recommendation='preferred'; rationale='Maps accepted descriptors to future dryrun inputs before any refresh execution.'}
  [pscustomobject]@{option='B'; next_scope='V432G_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_REVIEW_AND_REFRESH_GATE_OR_HOLD'; safety='review_gate'; recommendation='acceptable'; rationale='Adds review/gate before future refresh package.'}
  [pscustomobject]@{option='C'; next_scope='V432G_READONLY_REFRESH_DRYRUN_PACKAGE_REPAIR_OR_EXPANSION_OR_HOLD'; safety='package_only'; recommendation='acceptable_later'; rationale='Useful after mapping clarifies input needs.'}
  [pscustomobject]@{option='D'; next_scope='V432G_EV_DRYRUN_PRECONDITION_GAP_REVIEW_OR_HOLD'; safety='review_only'; recommendation='not_yet'; rationale='EV remains premature before descriptor-to-refresh mapping.'}
  [pscustomobject]@{option='E'; next_scope='HOLD'; safety='manual_direction'; recommendation='available'; rationale='Pause for user direction.'}
) | Export-Csv -LiteralPath $NextScopeMatrixPath -NoTypeInformation -Encoding UTF8
$ProofPath = Join-Path $ProofDir 'v432f_no_refresh_no_fetch_no_ev_no_trade_proof.txt'
@"
V432F boundary proof
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
Acceptance/planning only: true
"@ | Set-Content -LiteralPath $ProofPath -Encoding UTF8
$ReportPath = Join-Path $ReportDir 'v432f_source_descriptor_manifest_acceptance_and_next_scope_plan_or_hold_report.json'
$LatestPath = Join-Path $LatestDir 'v432f_source_descriptor_manifest_acceptance_and_next_scope_plan_or_hold_latest.json'
$FootprintPath = Join-Path $WordsDir "v432f_source_descriptor_manifest_acceptance_footprint_$Stamp.md"
$RootMirrorPath = Join-Path $RootWords "V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_$Stamp.md"
$GitRawPath = Join-Path $GitDir 'v432f_git_raw_footprint.txt'
$GitSummaryPath = Join-Path $GitDir 'v432f_git_summary.md'
$ScriptPath = Join-Path $OutRoot "00_EXECUTED_SCRIPT\RUN_${Stage}_${Stamp}.ps1"
$ScriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ScriptPath).Hash
$gitStatusBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -c core.longpaths=true -C $FootRepo status -sb
$headBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short HEAD
$originBefore = git -c safe.directory=C:/Users/sunpu/Desktop/pycson/00_GITHUB_FOOTPRINTS/pycson-footprints -C $FootRepo rev-parse --short origin/main
$report = [ordered]@{
  status = 'PASS_V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN'
  decision = 'READY_FOR_V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'
  stage = $Stage
  timestamp = $Stamp
  V432D_accepted = $true
  V432E_accepted = $true
  source_descriptor_manifest_milestone_accepted = $true
  acceptance_summary_created = $true
  evidence_register_created = $true
  remaining_gap_register_created = $true
  next_scope_options_created = $true
  recommended_next_scope = 'V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'
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
  acceptance_summary_path = $AcceptanceSummaryPath
  evidence_register_path = $EvidenceRegisterPath
  remaining_gap_register_path = $GapRegisterPath
  next_scope_option_matrix_path = $NextScopeMatrixPath
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
  next_safe_step = 'V432G_READONLY_REFRESH_DESCRIPTOR_TO_DRYRUN_INPUT_MAPPING_PLAN_OR_HOLD'
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
# V432F Footprint

Stage: $Stage
Status: $($report.status)
Decision: $($report.decision)
V432D accepted: true
V432E accepted: true
Milestone accepted: true
Recommended next scope: $($report.recommended_next_scope)
Boundaries: no refresh, no fetch, no scheduler, no UI patch, no DATA_BRIDGE, no active payload, no EV, no trade/order.
Executed script: $ScriptPath
Executed script SHA256: $ScriptHash
"@ | Set-Content -LiteralPath $FootprintPath -Encoding UTF8
Copy-Item -LiteralPath $FootprintPath -Destination $RootMirrorPath -Force
@"
V432F git raw footprint
HEAD before commit: $headBefore
origin/main before commit: $originBefore
Status before commit:
$($gitStatusBefore -join "`n")
"@ | Set-Content -LiteralPath $GitRawPath -Encoding UTF8
@"
# V432F Git Summary

- Stage: $Stage
- Status: $($report.status)
- Decision: $($report.decision)
- Latest JSON: $LatestPath
- Script path: $ScriptPath
- Script SHA256: $ScriptHash
- Safety summary: acceptance/planning only; no refresh/fetch/scheduler/write/EV/UI/trade action.
"@ | Set-Content -LiteralPath $GitSummaryPath -Encoding UTF8
$MirrorRoot = Join-Path $FootRepo "stage_mirror\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_$Stamp"
$null = New-Item -ItemType Directory -Force -Path $MirrorRoot
foreach ($p in @($ScriptPath,$AcceptanceSummaryPath,$EvidenceRegisterPath,$GapRegisterPath,$NextScopeMatrixPath,$ProofPath,$ReportPath,$LatestPath,$FootprintPath,$GitRawPath,$GitSummaryPath)) { Copy-Item -LiteralPath $p -Destination $MirrorRoot -Force }
$pathsToMake = @('version_reports','latest_mirror','raw_footprints_archive','git_summaries','words_mirror\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD','words_flat_mirror','root_footprint_copy_index_mirror') | ForEach-Object { Join-Path $FootRepo $_ }
$pathsToMake | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
Copy-Item -LiteralPath $ReportPath -Destination (Join-Path $FootRepo 'version_reports\v432f_source_descriptor_manifest_acceptance_and_next_scope_plan_or_hold_report.json') -Force
Copy-Item -LiteralPath $LatestPath -Destination (Join-Path $FootRepo 'latest_mirror\v432f_source_descriptor_manifest_acceptance_and_next_scope_plan_or_hold_latest.json') -Force
Copy-Item -LiteralPath $GitRawPath -Destination (Join-Path $FootRepo 'raw_footprints_archive\v432f_git_raw_footprint.txt') -Force
Copy-Item -LiteralPath $GitSummaryPath -Destination (Join-Path $FootRepo 'git_summaries\v432f_git_summary.md') -Force
Copy-Item -LiteralPath $FootprintPath -Destination (Join-Path $FootRepo "words_mirror\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD\v432f_source_descriptor_manifest_acceptance_footprint_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "words_flat_mirror\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_$Stamp.md") -Force
Copy-Item -LiteralPath $RootMirrorPath -Destination (Join-Path $FootRepo "root_footprint_copy_index_mirror\V432F_SOURCE_DESCRIPTOR_MANIFEST_ACCEPTANCE_AND_NEXT_SCOPE_PLAN_OR_HOLD_$Stamp.md") -Force
Write-Output "REPORT=$ReportPath"
Write-Output "LATEST=$LatestPath"
Write-Output "PROOF=$ProofPath"
Write-Output "FOOTPRINT=$FootprintPath"
Write-Output "ROOT_MIRROR=$RootMirrorPath"
Write-Output "GIT_RAW=$GitRawPath"
Write-Output "GIT_SUMMARY=$GitSummaryPath"

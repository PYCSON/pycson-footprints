param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$Stamp
)
$ErrorActionPreference = 'Stop'
$StageName = 'V431C_LOCAL_SAMPLE_MOCK_UNIVERSE_FIXTURE_OR_HOLD'
$SourceStage = Join-Path $ProjectRoot '1105_V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD\V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD_20260522_153149'
$RunRoot = Join-Path (Join-Path $ProjectRoot ('1107_' + $StageName)) ($StageName + '_' + $Stamp)
$FixtureDir = Join-Path $RunRoot '01_FIXTURE'
$ValidationDir = Join-Path $RunRoot '02_VALIDATION'
$BoundaryDir = Join-Path $RunRoot '03_BOUNDARY'
$ReportDir = Join-Path $RunRoot '04_REPORT'
$GitDir = Join-Path $RunRoot '05_GIT_FOOTPRINT'
$ScriptDir = Join-Path $RunRoot '00_EXECUTED_SCRIPT'
$LatestDir = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$WordsDir = Join-Path $ProjectRoot ('words.cossp\' + $StageName)
New-Item -ItemType Directory -Force -Path $FixtureDir,$ValidationDir,$BoundaryDir,$ReportDir,$GitDir,$LatestDir,$WordsDir | Out-Null

$UniverseSchemaPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_universe_index_schema.json'
$CandidateSchemaPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_candidate_class_schema.json'
$TemplateCsvPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_universe_template.csv'
$TaxonomyCsvPath = Join-Path $SourceStage '01_SCHEMA\readonly_universe_status_taxonomy.csv'
$UniverseSchema = Get-Content -Raw -LiteralPath $UniverseSchemaPath | ConvertFrom-Json
$CandidateSchema = Get-Content -Raw -LiteralPath $CandidateSchemaPath | ConvertFrom-Json
$TaxonomyRows = Import-Csv -LiteralPath $TaxonomyCsvPath

$universeRows = @(
  [ordered]@{universe_record_id='MOCK_LOCAL_001'; market_hash_name_placeholder='mock_case_item_alpha_placeholder'; display_name_placeholder='Mock Case Item Alpha'; app_id_assumption='730'; context_id_assumption='2'; item_category='MOCK_STEAM_READONLY_CASE_ITEM'; candidate_class='MOCK_FIXTURE_CANDIDATE'; collection_or_case_placeholder='mock_case_group_alpha'; rarity_placeholder='mock_rarity_blue'; stattrak_flag_placeholder='unknown'; wear_range_placeholder='mock_wear_range_any'; float_range_placeholder='mock_float_range_any'; source_confidence='UNVERIFIED'; review_status='MOCK_ONLY'; stale_status='UNKNOWN'; no_trade_flag=$true; no_fetch_flag=$true; notes='MOCK_ONLY LOCAL_ONLY NO_FETCH NO_TRADE fixture row; no live data'}
  [ordered]@{universe_record_id='MOCK_LOCAL_002'; market_hash_name_placeholder='mock_tradeup_input_beta_placeholder'; display_name_placeholder='Mock Tradeup Input Beta'; app_id_assumption='730'; context_id_assumption='2'; item_category='MOCK_TRADEUP_INPUT_CANDIDATE'; candidate_class='LOCAL_REFERENCE_CANDIDATE'; collection_or_case_placeholder='mock_collection_beta'; rarity_placeholder='mock_rarity_purple'; stattrak_flag_placeholder='false'; wear_range_placeholder='mock_factory_new_to_field_tested'; float_range_placeholder='mock_float_placeholder'; source_confidence='LOW'; review_status='LOCAL_ONLY'; stale_status='REVIEW_REQUIRED'; no_trade_flag=$true; no_fetch_flag=$true; notes='Local-only planning sample; not executable and no EV'}
  [ordered]@{universe_record_id='MOCK_LOCAL_003'; market_hash_name_placeholder='mock_output_pool_gamma_placeholder'; display_name_placeholder='Mock Output Pool Gamma'; app_id_assumption='730'; context_id_assumption='2'; item_category='MOCK_OUTPUT_POOL_PLACEHOLDER'; candidate_class='REVIEW_REQUIRED_CANDIDATE'; collection_or_case_placeholder='mock_output_pool_gamma'; rarity_placeholder='mock_rarity_red'; stattrak_flag_placeholder='unknown'; wear_range_placeholder='mock_output_wear_placeholder'; float_range_placeholder='mock_output_float_placeholder'; source_confidence='UNVERIFIED'; review_status='REVIEW_REQUIRED'; stale_status='UNKNOWN'; no_trade_flag=$true; no_fetch_flag=$true; notes='Review-required mock output pool placeholder; no price, no order, no EV'}
  [ordered]@{universe_record_id='MOCK_LOCAL_004'; market_hash_name_placeholder='mock_blocked_delta_placeholder'; display_name_placeholder='Mock Review Required Delta'; app_id_assumption='730'; context_id_assumption='2'; item_category='MOCK_REVIEW_REQUIRED_ITEM'; candidate_class='BLOCKED_BOUNDARY_CANDIDATE'; collection_or_case_placeholder='mock_blocked_group_delta'; rarity_placeholder='mock_rarity_gold'; stattrak_flag_placeholder='true'; wear_range_placeholder='mock_blocked_wear_placeholder'; float_range_placeholder='mock_blocked_float_placeholder'; source_confidence='UNVERIFIED'; review_status='BLOCKED'; stale_status='STALE'; no_trade_flag=$true; no_fetch_flag=$true; notes='Blocked boundary mock row; intentionally no live data and no trade route'}
)
$candidateRows = @(
  [ordered]@{candidate_class='MOCK_STEAM_READONLY_CASE_ITEM'; meaning='Fake case-item shaped fixture for schema and scheduler planning only'; allowed_without_fetch=$true; default_review_status='MOCK_ONLY'; trade_allowed=$false; downstream_use='May seed local mock universe fixture only'; boundary_note='NO_FETCH NO_TRADE NO_EV'}
  [ordered]@{candidate_class='MOCK_TRADEUP_INPUT_CANDIDATE'; meaning='Fake trade-up input category name for planning, not EV or execution'; allowed_without_fetch=$true; default_review_status='REVIEW_REQUIRED'; trade_allowed=$false; downstream_use='May support future candidate screening dryrun plan'; boundary_note='No trade-up EV and no execution'}
  [ordered]@{candidate_class='MOCK_OUTPUT_POOL_PLACEHOLDER'; meaning='Fake output pool placeholder for route shape planning only'; allowed_without_fetch=$true; default_review_status='UNVERIFIED'; trade_allowed=$false; downstream_use='May support future schema-only output pool review'; boundary_note='No live source and no executable value'}
  [ordered]@{candidate_class='MOCK_REVIEW_REQUIRED_ITEM'; meaning='Fake item requiring human review before any downstream route'; allowed_without_fetch=$true; default_review_status='REVIEW_REQUIRED'; trade_allowed=$false; downstream_use='May support review status handling tests'; boundary_note='Blocked from trading and EV'}
)

$mockFixturePath = Join-Path $FixtureDir 'steam_readonly_local_mock_universe_fixture.json'
$candidateFixturePath = Join-Path $FixtureDir 'steam_readonly_candidate_class_mock_fixture.json'
$universeRows | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath $mockFixturePath
$candidateRows | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 -LiteralPath $candidateFixturePath

$requiredUniverse = @($UniverseSchema.required)
$allowedCandidateClasses = @($UniverseSchema.properties.candidate_class.enum)
$allowedSourceConfidence = @($UniverseSchema.properties.source_confidence.enum)
$allowedReviewStatus = @($UniverseSchema.properties.review_status.enum)
$allowedStaleStatus = @($UniverseSchema.properties.stale_status.enum)
$requiredCandidate = @($CandidateSchema.required)
$allowedCandidateReviewStatus = @($CandidateSchema.properties.default_review_status.enum)

function Test-RequiredFields($row, $required) {
  foreach($field in $required) {
    if(-not $row.Contains($field)) { return $false }
    if($null -eq $row[$field] -or [string]$row[$field] -eq '') { return $false }
  }
  return $true
}

$universeConformance = foreach($row in $universeRows) {
  $requiredOk = Test-RequiredFields $row $requiredUniverse
  $enumOk = ($allowedCandidateClasses -contains $row.candidate_class) -and ($allowedSourceConfidence -contains $row.source_confidence) -and ($allowedReviewStatus -contains $row.review_status) -and ($allowedStaleStatus -contains $row.stale_status)
  $flagsOk = ($row.no_trade_flag -eq $true) -and ($row.no_fetch_flag -eq $true)
  [pscustomobject]@{record_id=$row.universe_record_id; required_fields_ok=$requiredOk; enum_values_ok=$enumOk; no_fetch_flag=$row.no_fetch_flag; no_trade_flag=$row.no_trade_flag; schema_conformant=($requiredOk -and $enumOk -and $flagsOk); local_mock_only=$true}
}
$candidateConformance = foreach($row in $candidateRows) {
  $requiredOk = Test-RequiredFields $row $requiredCandidate
  $enumOk = $allowedCandidateReviewStatus -contains $row.default_review_status
  $flagsOk = ($row.allowed_without_fetch -eq $true) -and ($row.trade_allowed -eq $false)
  [pscustomobject]@{candidate_class=$row.candidate_class; required_fields_ok=$requiredOk; enum_values_ok=$enumOk; allowed_without_fetch=$row.allowed_without_fetch; trade_allowed=$row.trade_allowed; schema_conformant=($requiredOk -and $enumOk -and $flagsOk); local_mock_only=$true}
}
$SchemaConformant = (@($universeConformance | Where-Object { -not $_.schema_conformant }).Count -eq 0) -and (@($candidateConformance | Where-Object { -not $_.schema_conformant }).Count -eq 0)

$ForbiddenPatterns = @('live_price','executable_price','order_book_depth','liquidity_score_from_live_source','trusted_ev','official_ev','trade_up_ev','tradeup_ev','buy_price','sell_price','buy_now','tradeup_now','order_action','trade_action','account','session','token','cookie','steam_response','buff_response','executable_profit')
$fixtureText = (Get-Content -Raw -LiteralPath $mockFixturePath) + "`n" + (Get-Content -Raw -LiteralPath $candidateFixturePath)
$forbiddenScanRows = foreach($pattern in $ForbiddenPatterns) {
  $present = $fixtureText -match [regex]::Escape($pattern)
  [pscustomobject]@{forbidden_pattern=$pattern; present=$present; review=($(if($present){'HOLD'}else{'PASS'}))}
}
$ForbiddenAbsent = @($forbiddenScanRows | Where-Object { $_.present }).Count -eq 0

$conformancePath = Join-Path $ValidationDir 'schema_conformance_checklist.csv'
@($universeConformance + $candidateConformance) | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $conformancePath
$forbiddenScanPath = Join-Path $ValidationDir 'forbidden_field_scan.csv'
$forbiddenScanRows | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $forbiddenScanPath
$validationReportPath = Join-Path $ValidationDir 'mock_fixture_validation_report.md'
$mockLocalOnly = $SchemaConformant -and $ForbiddenAbsent -and (@($universeRows | Where-Object { $_.review_status -notin @('MOCK_ONLY','LOCAL_ONLY','REVIEW_REQUIRED','BLOCKED','UNVERIFIED','NO_TRADE','STALE') }).Count -eq 0)
@"
# V431C Mock Fixture Validation Report

Stage: $StageName
Generated: $Stamp

Validation conclusion: $(if($SchemaConformant -and $ForbiddenAbsent -and $mockLocalOnly){'PASS'}else{'HOLD'})

Checks:
- Universe fixture rows: $(@($universeRows).Count)
- Candidate class fixture rows: $(@($candidateRows).Count)
- Schema conformance validated: $SchemaConformant
- Forbidden fields absent: $ForbiddenAbsent
- Mock/local only confirmed: $mockLocalOnly
- All universe rows set no_fetch_flag=true and no_trade_flag=true: $(@($universeRows | Where-Object { $_.no_fetch_flag -ne $true -or $_.no_trade_flag -ne $true }).Count -eq 0)
- Candidate rows set allowed_without_fetch=true and trade_allowed=false: $(@($candidateRows | Where-Object { $_.allowed_without_fetch -ne $true -or $_.trade_allowed -ne $false }).Count -eq 0)

No Steam fetch, BUFF fetch, market endpoint call, DATA_BRIDGE write, active payload write, UI modification, EV calculation, BUY_NOW, TRADEUP_NOW, trade, or order occurred.
"@ | Set-Content -Encoding UTF8 -LiteralPath $validationReportPath

$futureNotesPath = Join-Path $ValidationDir 'future_candidate_screening_readiness_notes.md'
@"
# V431C Future Candidate Screening Readiness Notes

This fixture is suitable for planning-only future V431D/V431E work because it contains multiple safe local states: MOCK_ONLY, LOCAL_ONLY, REVIEW_REQUIRED, and BLOCKED.

Allowed future use:
- Validate local schema readers.
- Plan bounded scheduler dryrun inputs without fetching.
- Plan candidate screening statuses without EV or trading.

Forbidden without explicit future approval:
- Steam fetch or BUFF fetch.
- DATA_BRIDGE write or active payload write.
- Official/trusted/trade-up EV calculation.
- BUY_NOW, TRADEUP_NOW, trade, or order.
- Any live price, executable price, order book, liquidity-from-live-source, token, cookie, session, account, or proprietary mapping export.
"@ | Set-Content -Encoding UTF8 -LiteralPath $futureNotesPath

$proofPath = Join-Path $BoundaryDir 'no_write_no_fetch_no_ev_no_trade_proof.txt'
@"
V431C local mock universe fixture boundary proof
Stage: $StageName
Generated: $Stamp

Local mock/sample fixture only: true
No UI patch performed: true
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
Steam fetch: false
BUFF fetch: false
Market endpoint call: false
Official/trusted/trade-up EV calculation: false
BUY/TRADE/ORDER: false
FAICTORY touched: false
Fixture fields are mock/local/schema-only and no_fetch/no_trade flagged.
"@ | Set-Content -Encoding UTF8 -LiteralPath $proofPath

$scriptPath = Get-ChildItem -LiteralPath $ScriptDir -Filter ('RUN_' + $StageName + '_' + $Stamp + '.ps1') | Select-Object -First 1 -ExpandProperty FullName
$scriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $scriptPath).Hash
$PassLocal = $SchemaConformant -and $ForbiddenAbsent -and $mockLocalOnly
$status = if($PassLocal){'PASS_V431C_LOCAL_SAMPLE_MOCK_UNIVERSE_FIXTURE'}else{'HOLD_FOR_V431C_MOCK_FIXTURE_VALIDATION_REPAIR'}
$decision = if($PassLocal){'READY_FOR_V431C_SAFE_FOOTPRINT_EXPORT_OR_V431D_V431E_PLANNING'}else{'HOLD_FOR_MOCK_FIXTURE_REPAIR'}
$reportPath = Join-Path $ReportDir 'v431c_local_sample_mock_universe_fixture_or_hold_report.json'
$latestPath = Join-Path $LatestDir 'v431c_local_sample_mock_universe_fixture_or_hold_latest.json'
$footprintPath = Join-Path $WordsDir ('v431c_local_mock_universe_fixture_footprint_' + $Stamp + '.md')
$gitRawPath = Join-Path $GitDir 'v431c_git_raw_footprint.txt'
$gitSummaryPath = Join-Path $GitDir 'v431c_git_summary.md'
$report = [ordered]@{
  status=$status; decision=$decision; stage=$StageName; generated_at=$Stamp; project_root=$ProjectRoot;
  executed_script_path=$scriptPath; executed_script_sha256=$scriptHash;
  mock_universe_fixture_created=$true; candidate_class_fixture_created=$true; schema_conformance_validated=$SchemaConformant; forbidden_fields_absent=$ForbiddenAbsent; mock_local_only_confirmed=$mockLocalOnly;
  no_ui_patch_performed=$true; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; steam_fetch=$false; buff_fetch=$false; ev_calculation=$false; buy_trade_order=$false;
  mock_fixture_path=$mockFixturePath; candidate_fixture_path=$candidateFixturePath; validation_report_path=$validationReportPath; schema_conformance_checklist_path=$conformancePath; forbidden_field_scan_path=$forbiddenScanPath; future_readiness_notes_path=$futureNotesPath; proof_path=$proofPath; footprint_path=$footprintPath; git_raw_footprint_path=$gitRawPath; git_summary_path=$gitSummaryPath;
  next_safe_step='V431D_BOUNDED_REFRESH_SCHEDULER_PLAN_OR_V431E_CANDIDATE_SCREENING_PLAN_OR_HOLD_AFTER_SAFE_EXPORT'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $reportPath
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $latestPath
@"
# V431C Local Mock Universe Fixture Footprint

Status: $status
Decision: $decision
Generated: $Stamp

Created schema-conformant local/mock-only Steam readonly universe fixture and candidate class fixture. All rows are no-fetch/no-trade and contain no live source, EV, credential, price, order book, or executable trade fields.

Safety summary:
- No UI patch.
- No DATA_BRIDGE write.
- No active payload write.
- No Steam/BUFF fetch or market endpoint call.
- No official/trusted/trade-up EV calculation.
- No BUY/TRADE/ORDER.

Executed script: $scriptPath
Executed script SHA256: $scriptHash
Report JSON: $reportPath
Latest JSON: $latestPath
Proof: $proofPath
"@ | Set-Content -Encoding UTF8 -LiteralPath $footprintPath
@"
Stage: $StageName
Status: $status
Decision: $decision
Latest JSON: $latestPath
Report JSON: $reportPath
Executed script: $scriptPath
Executed script SHA256: $scriptHash
Safety: local mock/sample fixture only, no fetch/write/EV/UI/trade.
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitSummaryPath
@"
V431C local mock universe fixture git raw footprint placeholder before commit.
Generated: $Stamp
Stage: $StageName
Safe fixture/report/proof artifacts only; no source backups, credentials, live data, or proprietary mapping.
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitRawPath
Write-Output ($report | ConvertTo-Json -Depth 8)

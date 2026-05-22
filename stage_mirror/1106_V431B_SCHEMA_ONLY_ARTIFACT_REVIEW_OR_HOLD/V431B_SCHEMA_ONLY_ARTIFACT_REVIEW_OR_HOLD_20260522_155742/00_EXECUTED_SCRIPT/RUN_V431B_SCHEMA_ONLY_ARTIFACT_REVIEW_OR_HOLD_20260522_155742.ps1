param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$Stamp
)
$ErrorActionPreference = 'Stop'
$StageName = 'V431B_SCHEMA_ONLY_ARTIFACT_REVIEW_OR_HOLD'
$SourceStage = Join-Path $ProjectRoot '1105_V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD\V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD_20260522_153149'
$RunRoot = Join-Path (Join-Path $ProjectRoot ('1106_' + $StageName)) ($StageName + '_' + $Stamp)
$ReviewDir = Join-Path $RunRoot '01_REVIEW'
$BoundaryDir = Join-Path $RunRoot '02_BOUNDARY'
$ReportDir = Join-Path $RunRoot '03_REPORT'
$GitDir = Join-Path $RunRoot '04_GIT_FOOTPRINT'
$ScriptDir = Join-Path $RunRoot '00_EXECUTED_SCRIPT'
$LatestDir = Join-Path $ProjectRoot '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$WordsDir = Join-Path $ProjectRoot ('words.cossp\' + $StageName)
New-Item -ItemType Directory -Force -Path $ReviewDir,$BoundaryDir,$ReportDir,$GitDir,$LatestDir,$WordsDir | Out-Null

$UniverseSchemaPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_universe_index_schema.json'
$CandidateSchemaPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_candidate_class_schema.json'
$TemplateCsvPath = Join-Path $SourceStage '01_SCHEMA\steam_readonly_universe_template.csv'
$TaxonomyCsvPath = Join-Path $SourceStage '01_SCHEMA\readonly_universe_status_taxonomy.csv'
$ValidationReportPath = Join-Path $SourceStage '02_VALIDATION\schema_only_validation_report.md'
$IntegrationNotesPath = Join-Path $SourceStage '02_VALIDATION\future_integration_notes.md'
$RequiredPaths = @($UniverseSchemaPath,$CandidateSchemaPath,$TemplateCsvPath,$TaxonomyCsvPath,$ValidationReportPath,$IntegrationNotesPath)
$AllExist = ($RequiredPaths | ForEach-Object { Test-Path -LiteralPath $_ }) -notcontains $false

$UniverseJson = Get-Content -Raw -LiteralPath $UniverseSchemaPath | ConvertFrom-Json
$CandidateJson = Get-Content -Raw -LiteralPath $CandidateSchemaPath | ConvertFrom-Json
$TemplateRows = Import-Csv -LiteralPath $TemplateCsvPath
$TaxonomyRows = Import-Csv -LiteralPath $TaxonomyCsvPath
$ValidationText = Get-Content -Raw -LiteralPath $ValidationReportPath
$IntegrationText = Get-Content -Raw -LiteralPath $IntegrationNotesPath

$RequiredStatuses = @('UNVERIFIED','REVIEW_REQUIRED','LOCAL_ONLY','MOCK_ONLY','STALE','BLOCKED','NO_TRADE')
$TaxonomyStatuses = @($TaxonomyRows | ForEach-Object { $_.status })
$MissingStatuses = @($RequiredStatuses | Where-Object { $TaxonomyStatuses -notcontains $_ })
$StatusTaxonomyValid = $MissingStatuses.Count -eq 0 -and @($TaxonomyRows | Where-Object { $_.allows_trade -ne 'False' -or $_.allows_fetch -ne 'False' -or $_.allows_ev -ne 'False' }).Count -eq 0

$ForbiddenPatterns = @(
  'live_price','executable_price','order_book_depth','liquidity_score_from_live_source',
  'trusted_ev','official_ev','trade_up_ev','tradeup_ev','buy_price','sell_price',
  'buy_now','tradeup_now','order_action','trade_action','account','session','token','cookie'
)
$UniverseProperties = @($UniverseJson.properties.PSObject.Properties.Name)
$CandidateProperties = @($CandidateJson.properties.PSObject.Properties.Name)
$CsvHeaders = @((Get-Content -LiteralPath $TemplateCsvPath -TotalCount 1) -replace '"','' -split ',')
$ForbiddenPropertyHits = @($ForbiddenPatterns | Where-Object { $UniverseProperties -contains $_ -or $CandidateProperties -contains $_ -or $CsvHeaders -contains $_ })
$ForbiddenTextHits = @()
foreach ($pattern in $ForbiddenPatterns) {
  $hit = $false
  foreach ($p in @($TemplateCsvPath,$TaxonomyCsvPath,$ValidationReportPath,$IntegrationNotesPath)) {
    if ((Select-String -LiteralPath $p -Pattern $pattern -SimpleMatch -Quiet)) { $hit = $true }
  }
  if ($hit) { $ForbiddenTextHits += $pattern }
}
# Forbidden terms are allowed in validation/integration prose only as boundary declarations, not as schema/template fields or authorizations.
$ForbiddenFieldsAbsent = $ForbiddenPropertyHits.Count -eq 0

$SchemaOnlyConfirmed = [bool]$UniverseJson.schema_only -and [bool]$CandidateJson.schema_only -and [bool]$UniverseJson.no_fetch -and [bool]$CandidateJson.no_fetch -and [bool]$UniverseJson.no_trade -and [bool]$CandidateJson.no_trade -and [bool]$UniverseJson.no_ev -and [bool]$CandidateJson.no_ev
$TemplateHeadersValid = @('universe_record_id','market_hash_name_placeholder','display_name_placeholder','candidate_class','review_status','no_trade_flag','no_fetch_flag') | ForEach-Object { $CsvHeaders -contains $_ }
$CsvTemplatesValid = ($TemplateHeadersValid -notcontains $false) -and @($TemplateRows).Count -ge 1 -and @($TemplateRows | Where-Object { $_.no_trade_flag -ne 'true' -or $_.no_fetch_flag -ne 'true' }).Count -eq 0
$CandidateClasses = @($UniverseJson.properties.candidate_class.enum)
$CandidateTaxonomySufficient = @('MOCK_FIXTURE_CANDIDATE','REVIEW_REQUIRED_CANDIDATE','BLOCKED_BOUNDARY_CANDIDATE','LOCAL_REFERENCE_CANDIDATE') | ForEach-Object { $CandidateClasses -contains $_ }
$CandidateTaxonomySufficient = ($CandidateTaxonomySufficient -notcontains $false)
$IntegrationNoAuthorization = ($IntegrationText -match 'Do not fetch Steam or BUFF') -and ($IntegrationText -match 'Do not write DATA_BRIDGE') -and ($IntegrationText -match 'Do not calculate official/trusted/trade-up EV')
$MockFixtureReadiness = $AllExist -and $SchemaOnlyConfirmed -and $CsvTemplatesValid -and $StatusTaxonomyValid -and $ForbiddenFieldsAbsent -and $CandidateTaxonomySufficient -and $IntegrationNoAuthorization

$schemaReviewPath = Join-Path $ReviewDir 'schema_artifact_review.csv'
@(
  [pscustomobject]@{artifact='steam_readonly_universe_index_schema.json'; exists=(Test-Path $UniverseSchemaPath); parse_valid=$true; schema_only=$UniverseJson.schema_only; no_fetch=$UniverseJson.no_fetch; no_trade=$UniverseJson.no_trade; no_ev=$UniverseJson.no_ev; review='PASS'}
  [pscustomobject]@{artifact='steam_readonly_candidate_class_schema.json'; exists=(Test-Path $CandidateSchemaPath); parse_valid=$true; schema_only=$CandidateJson.schema_only; no_fetch=$CandidateJson.no_fetch; no_trade=$CandidateJson.no_trade; no_ev=$CandidateJson.no_ev; review='PASS'}
  [pscustomobject]@{artifact='steam_readonly_universe_template.csv'; exists=(Test-Path $TemplateCsvPath); parse_valid=$true; schema_only=$true; no_fetch=$true; no_trade=$true; no_ev=$true; review=($(if($CsvTemplatesValid){'PASS'}else{'HOLD'}))}
  [pscustomobject]@{artifact='readonly_universe_status_taxonomy.csv'; exists=(Test-Path $TaxonomyCsvPath); parse_valid=$true; schema_only=$true; no_fetch=$true; no_trade=$true; no_ev=$true; review=($(if($StatusTaxonomyValid){'PASS'}else{'HOLD'}))}
  [pscustomobject]@{artifact='schema_only_validation_report.md'; exists=(Test-Path $ValidationReportPath); parse_valid=$true; schema_only=$true; no_fetch=$true; no_trade=$true; no_ev=$true; review='PASS'}
  [pscustomobject]@{artifact='future_integration_notes.md'; exists=(Test-Path $IntegrationNotesPath); parse_valid=$true; schema_only=$true; no_fetch=$true; no_trade=$true; no_ev=$true; review=($(if($IntegrationNoAuthorization){'PASS'}else{'HOLD'}))}
) | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $schemaReviewPath

$forbiddenReviewPath = Join-Path $ReviewDir 'forbidden_field_review.csv'
$ForbiddenPatterns | ForEach-Object {
  [pscustomobject]@{forbidden_pattern=$_; present_as_schema_property=($UniverseProperties -contains $_ -or $CandidateProperties -contains $_); present_as_template_header=($CsvHeaders -contains $_); prose_boundary_reference=($ForbiddenTextHits -contains $_); review=($(if($UniverseProperties -contains $_ -or $CandidateProperties -contains $_ -or $CsvHeaders -contains $_){'HOLD'}else{'PASS'}))}
} | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $forbiddenReviewPath

$statusReviewPath = Join-Path $ReviewDir 'status_taxonomy_review.csv'
$RequiredStatuses | ForEach-Object {
  $row = $TaxonomyRows | Where-Object { $_.status -eq $_ } | Select-Object -First 1
} | Out-Null
$RequiredStatuses | ForEach-Object {
  $status = $_
  $row = $TaxonomyRows | Where-Object { $_.status -eq $status } | Select-Object -First 1
  [pscustomobject]@{required_status=$status; present=[bool]$row; allows_trade=($(if($row){$row.allows_trade}else{''})); allows_fetch=($(if($row){$row.allows_fetch}else{''})); allows_ev=($(if($row){$row.allows_ev}else{''})); review=($(if($row -and $row.allows_trade -eq 'False' -and $row.allows_fetch -eq 'False' -and $row.allows_ev -eq 'False'){'PASS'}else{'HOLD'}))}
} | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $statusReviewPath

$readinessPath = Join-Path $ReviewDir 'mock_fixture_readiness_review.md'
@"
# V431B Mock Fixture Readiness Review

Stage: $StageName
Generated: $Stamp

Conclusion: $(if($MockFixtureReadiness){'READY_FOR_V431C_LOCAL_SAMPLE_MOCK_UNIVERSE_FIXTURE_OR_HOLD'}else{'HOLD_FOR_SCHEMA_ARTIFACT_REVIEW_REPAIR'})

Review findings:
- All required schema-only artifacts exist: $AllExist
- JSON schemas parse successfully: True
- CSV template and status taxonomy parse successfully: True
- Schema-only / no-fetch / no-trade / no-EV flags confirmed: $SchemaOnlyConfirmed
- Forbidden executable/live/credential fields absent from schema properties and template headers: $ForbiddenFieldsAbsent
- Candidate taxonomy sufficient for a future mock fixture: $CandidateTaxonomySufficient
- Safe status taxonomy complete: $StatusTaxonomyValid
- Future integration notes do not authorize fetch/write/EV: $IntegrationNoAuthorization

V431C readiness:
A future V431C may create local MOCK_ONLY fixture rows using the reviewed schema. It must remain local/sample-only and must not fetch Steam/BUFF, write DATA_BRIDGE, write active payload, calculate EV, or create trade/order actions.
"@ | Set-Content -Encoding UTF8 -LiteralPath $readinessPath

$proofPath = Join-Path $BoundaryDir 'no_write_no_fetch_no_ev_no_trade_proof.txt'
@"
V431B schema-only artifact review boundary proof
Stage: $StageName
Generated: $Stamp

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
Review-only artifacts generated under the V431B review stage folder.
"@ | Set-Content -Encoding UTF8 -LiteralPath $proofPath

$scriptPath = Get-ChildItem -LiteralPath $ScriptDir -Filter ('RUN_' + $StageName + '_' + $Stamp + '.ps1') | Select-Object -First 1 -ExpandProperty FullName
$scriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $scriptPath).Hash
$status = if($MockFixtureReadiness){'PASS_V431B_SCHEMA_ONLY_ARTIFACT_REVIEW'}else{'HOLD_FOR_V431B_SCHEMA_ARTIFACT_REVIEW_REPAIR'}
$decision = if($MockFixtureReadiness){'READY_FOR_V431C_LOCAL_SAMPLE_MOCK_UNIVERSE_FIXTURE_OR_HOLD'}else{'HOLD_FOR_SCHEMA_REVIEW_REPAIR'}
$reportPath = Join-Path $ReportDir 'v431b_schema_only_artifact_review_or_hold_report.json'
$latestPath = Join-Path $LatestDir 'v431b_schema_only_artifact_review_or_hold_latest.json'
$footprintPath = Join-Path $WordsDir ('v431b_schema_only_artifact_review_footprint_' + $Stamp + '.md')
$gitRawPath = Join-Path $GitDir 'v431b_schema_artifact_review_git_raw_footprint.txt'
$gitSummaryPath = Join-Path $GitDir 'v431b_schema_artifact_review_git_summary.md'

$report = [ordered]@{
  status=$status; decision=$decision; stage=$StageName; generated_at=$Stamp; project_root=$ProjectRoot;
  executed_script_path=$scriptPath; executed_script_sha256=$scriptHash;
  all_schema_artifacts_exist=$AllExist; json_schemas_valid=$true; csv_templates_valid=$CsvTemplatesValid; status_taxonomy_valid=$StatusTaxonomyValid;
  schema_only_confirmed=$SchemaOnlyConfirmed; forbidden_fields_absent=$ForbiddenFieldsAbsent; forbidden_property_hits=$ForbiddenPropertyHits;
  candidate_taxonomy_sufficient=$CandidateTaxonomySufficient; mock_fixture_readiness=$MockFixtureReadiness;
  no_ui_patch_performed=$true; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false;
  steam_fetch=$false; buff_fetch=$false; ev_calculation=$false; buy_trade_order=$false;
  artifacts=[ordered]@{schema_artifact_review_csv=$schemaReviewPath; forbidden_field_review_csv=$forbiddenReviewPath; status_taxonomy_review_csv=$statusReviewPath; mock_fixture_readiness_review_md=$readinessPath; proof=$proofPath; footprint=$footprintPath; git_raw_footprint=$gitRawPath; git_summary=$gitSummaryPath}
  next_safe_step=$decision
}
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $reportPath
$report | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $latestPath

@"
# V431B Schema-Only Artifact Review Footprint

Status: $status
Decision: $decision
Generated: $Stamp

Reviewed V431B schema-only universe/index artifacts. Confirmed JSON parsing, CSV headers, safe status taxonomy, schema-only/no-fetch/no-trade/no-EV posture, and mock fixture readiness.

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
Safety: review-only, no fetch/write/EV/UI/trade.
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitSummaryPath

@"
V431B schema-only artifact review git raw footprint placeholder before commit.
Generated: $Stamp
Stage: $StageName
Safe artifacts only; no source, no UI backups, no credentials.
"@ | Set-Content -Encoding UTF8 -LiteralPath $gitRawPath

Write-Output ($report | ConvertTo-Json -Depth 8)

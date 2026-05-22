param([string]$Root,[string]$RunDir,[string]$Stamp,[string]$StageName)
$ErrorActionPreference='Stop'
$planDir=Join-Path $RunDir '01_PLAN'
$schemaDir=Join-Path $RunDir '02_SCHEMA'
$boundaryDir=Join-Path $RunDir '03_BOUNDARY'
$reportDir=Join-Path $RunDir '04_REPORT'
$gitDir=Join-Path $RunDir '05_GIT_FOOTPRINT'
$latestDir=Join-Path $Root '11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX'
$wordsDir=Join-Path $Root 'words.cossp\V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD'
New-Item -ItemType Directory -Force -Path $wordsDir | Out-Null
$planningMd=Join-Path $planDir 'steam_readonly_universe_index_planning.md'
$schemaJson=Join-Path $schemaDir 'proposed_universe_schema_draft.json'
$taxonomyCsv=Join-Path $schemaDir 'candidate_class_taxonomy.csv'
$boundaryCsv=Join-Path $schemaDir 'no_fetch_boundary_checklist.csv'
$futureCsv=Join-Path $schemaDir 'future_stage_option_matrix.csv'
$integrationMd=Join-Path $planDir 'integration_readiness_notes.md'
$proof=Join-Path $boundaryDir 'no_write_no_fetch_no_ev_no_trade_proof.txt'
$reportPath=Join-Path $reportDir 'v431a_steam_readonly_universe_index_planning_or_hold_report.json'
$latestPath=Join-Path $latestDir 'v431a_steam_readonly_universe_index_planning_or_hold_latest.json'
$footprint=Join-Path $wordsDir ('v431a_steam_readonly_universe_index_planning_footprint_'+$Stamp+'.md')
$gitRaw=Join-Path $gitDir 'v431a_git_raw_footprint.txt'
$gitSummary=Join-Path $gitDir 'v431a_git_summary.md'
@"
# V431A Steam Readonly Universe / Index Planning

Stage: $StageName
Generated: $Stamp

## Meaning

A Steam readonly universe/index in PYCSON is a local, planning-first description of possible Steam item identities and review states. It is not a market fetcher, not a price engine, not an EV engine, not a DATA_BRIDGE writer, and not a trade executor.

The layer should eventually help downstream planning answer: what item identities can be discussed locally, what placeholder fields are allowed before fetch/EV approval, what confidence/staleness/review status applies, and what must remain blocked.

## Allowed Future Data Classes Without Fetching

- market_hash_name
- app/context assumptions
- item display name
- collection/case grouping placeholder
- rarity placeholder
- StatTrak flag placeholder
- wear/float range placeholder
- candidate class
- source confidence
- stale status
- review status
- no-trade flag

## Forbidden Fields In This Stage

- live price
- executable price
- trusted EV
- official EV
- order book depth
- buy/sell instruction
- token/cookie/account/session data

## Allowed Planning Artifacts

- schema draft
- candidate class taxonomy
- no-fetch boundary checklist
- future integration map
- review status map
- handoff notes

## Safety Statuses

- UNVERIFIED
- REVIEW_REQUIRED
- LOCAL_ONLY
- MOCK_ONLY
- STALE
- BLOCKED
- NO_TRADE

## Future Stage Options

- V431B schema-only artifact build
- V431C local sample/mock universe fixture
- V431D bounded refresh scheduler plan
- V431E candidate screening plan

## Must Not Happen Before Explicit Future Approval

- no Steam fetch
- no BUFF fetch
- no DATA_BRIDGE write
- no active payload write
- no EV calculation
- no UI patch
- no trading action
"@ | Set-Content -LiteralPath $planningMd -Encoding UTF8
$schema=[ordered]@{
 schema_version='V431A_DRAFT_ONLY'
 readonly=$true
 generated_stage=$StageName
 no_fetch=$true
 no_ev=$true
 no_trade=$true
 record=[ordered]@{
  universe_item_id='string_local_planning_id'
  market_hash_name='string_placeholder_no_fetch'
  app_id_assumption='string_or_null_planning_only'
  context_id_assumption='string_or_null_planning_only'
  item_display_name='string_placeholder'
  collection_or_case_grouping='string_placeholder_or_unknown'
  rarity='string_placeholder_or_unknown'
  stattrak_flag='boolean_or_unknown_placeholder'
  wear_float_range='string_placeholder_or_unknown'
  candidate_class='enum_planning_taxonomy'
  source_confidence='enum_low_medium_high_unverified'
  stale_status='enum_current_unknown_stale'
  review_status='enum_UNVERIFIED_REVIEW_REQUIRED_LOCAL_ONLY_MOCK_ONLY_STALE_BLOCKED_NO_TRADE'
  no_trade_flag='boolean_required_true_until_future_approval'
  notes='string_planning_notes_only'
 }
 forbidden_fields=@('live_price','executable_price','trusted_ev','official_ev','order_book_depth','buy_instruction','sell_instruction','token','cookie','account','session')
}
$schema | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $schemaJson -Encoding UTF8
$taxonomyRows=@(
 [pscustomobject]@{candidate_class='UNIVERSE_IDENTITY_PLACEHOLDER';meaning='Known or proposed item identity shell';allowed_without_fetch=$true;review_status='UNVERIFIED';trade_allowed=$false},
 [pscustomobject]@{candidate_class='LOCAL_REFERENCE_CANDIDATE';meaning='Local-only candidate from approved local planning context';allowed_without_fetch=$true;review_status='LOCAL_ONLY';trade_allowed=$false},
 [pscustomobject]@{candidate_class='MOCK_FIXTURE_CANDIDATE';meaning='Synthetic sample for schema testing';allowed_without_fetch=$true;review_status='MOCK_ONLY';trade_allowed=$false},
 [pscustomobject]@{candidate_class='STALE_REVIEW_CANDIDATE';meaning='Previously known item requiring stale review';allowed_without_fetch=$true;review_status='STALE';trade_allowed=$false},
 [pscustomobject]@{candidate_class='BLOCKED_BOUNDARY_CANDIDATE';meaning='Candidate blocked by missing approval or unsafe source';allowed_without_fetch=$true;review_status='BLOCKED';trade_allowed=$false},
 [pscustomobject]@{candidate_class='REVIEW_REQUIRED_CANDIDATE';meaning='Candidate may be discussed but needs human review before downstream use';allowed_without_fetch=$true;review_status='REVIEW_REQUIRED';trade_allowed=$false}
)
$taxonomyRows | Export-Csv -LiteralPath $taxonomyCsv -NoTypeInformation -Encoding UTF8
$boundaryRows=@(
 [pscustomobject]@{boundary='no_steam_fetch';required=$true;stage_occurrence=$false;note='No Steam endpoint call'},
 [pscustomobject]@{boundary='no_buff_fetch';required=$true;stage_occurrence=$false;note='No BUFF endpoint call'},
 [pscustomobject]@{boundary='no_market_endpoint';required=$true;stage_occurrence=$false;note='No market network request'},
 [pscustomobject]@{boundary='no_databridge_write';required=$true;stage_occurrence=$false;note='No DATA_BRIDGE write'},
 [pscustomobject]@{boundary='no_active_payload_write';required=$true;stage_occurrence=$false;note='No active payload write'},
 [pscustomobject]@{boundary='no_ev_calculation';required=$true;stage_occurrence=$false;note='No official/trusted EV'},
 [pscustomobject]@{boundary='no_ui_patch';required=$true;stage_occurrence=$false;note='No V200 UI modification'},
 [pscustomobject]@{boundary='no_trade_action';required=$true;stage_occurrence=$false;note='No BUY_NOW TRADEUP_NOW trade/order'}
)
$boundaryRows | Export-Csv -LiteralPath $boundaryCsv -NoTypeInformation -Encoding UTF8
$futureRows=@(
 [pscustomobject]@{stage='V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD';purpose='Create schema artifact only';risk='low';requires_fetch=$false;requires_ev=$false;requires_databridge_write=$false;recommended_order=1},
 [pscustomobject]@{stage='V431C_LOCAL_SAMPLE_MOCK_UNIVERSE_FIXTURE_OR_HOLD';purpose='Create local mock fixture';risk='low_medium';requires_fetch=$false;requires_ev=$false;requires_databridge_write=$false;recommended_order=2},
 [pscustomobject]@{stage='V431D_BOUNDED_REFRESH_SCHEDULER_PLAN_OR_HOLD';purpose='Plan bounded refresh scheduler without execution';risk='medium';requires_fetch=$false;requires_ev=$false;requires_databridge_write=$false;recommended_order=3},
 [pscustomobject]@{stage='V431E_CANDIDATE_SCREENING_PLAN_OR_HOLD';purpose='Plan screening rules and review statuses';risk='medium';requires_fetch=$false;requires_ev=$false;requires_databridge_write=$false;recommended_order=4}
)
$futureRows | Export-Csv -LiteralPath $futureCsv -NoTypeInformation -Encoding UTF8
@"
# V431A Integration Readiness Notes

This stage prepares architecture only. It does not integrate with DATA_BRIDGE, active payload, UI, Steam, BUFF, EV, or trading paths.

Future integration readiness requires:
- schema-only artifact accepted first;
- local mock fixture accepted before any live-source work;
- explicit approval before scheduler planning becomes execution;
- explicit approval before any Steam/BUFF fetch;
- explicit approval before any DATA_BRIDGE or active payload write;
- explicit approval before any official/trusted EV route;
- explicit approval before any UI display update.

Recommended immediate next stage: V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD.
"@ | Set-Content -LiteralPath $integrationMd -Encoding UTF8
@"
V431A no-write/no-fetch/no-EV/no-trade proof
Stage: $StageName
Generated: $Stamp
Planning/package only: true
UI patch performed: false
Mother UI modified: false
LIVE UI modified: false
DATA_BRIDGE write: false
Active payload write: false
Steam fetch: false
BUFF fetch: false
Market endpoint call: false
Official EV calculated: false
Trusted EV calculated: false
BUY_NOW / TRADEUP_NOW / trade/order executed: false
FAICTORY touched: false
Legacy/archive moved or deleted: false
"@ | Set-Content -LiteralPath $proof -Encoding UTF8
$status='PASS_HOLD_V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_READY_SAFE_FOOTPRINT_EXPORT_APPROVAL_REQUIRED'
$decision='HOLD_FOR_USER_APPROVAL_OF_V431A_SAFE_FOOTPRINT_EXPORT_BEFORE_V431B'
$report=[ordered]@{
 status=$status; decision=$decision; project_root_confirmed=$Root; current_anchor='V431_SAFE_FOOTPRINT_EXPORT_FINALIZATION_COMPLETE'; current_head='a44fa6d';
 planning_package_created=$true; schema_draft_created=$true; candidate_taxonomy_created=$true; no_fetch_boundary_checklist_created=$true; future_stage_options_created=$true; integration_readiness_notes_created=$true;
 no_ui_patch_performed=$true; mother_ui_modified=$false; live_ui_modified=$false; data_bridge_write=$false; active_payload_write=$false; steam_fetch=$false; buff_fetch=$false; ev_calculation=$false; buy_trade_order=$false;
 report_json=$reportPath; latest_json=$latestPath; proof=$proof; footprint=$footprint; git_raw_footprint=$gitRaw; git_summary=$gitSummary;
 planning_markdown=$planningMd; schema_draft=$schemaJson; candidate_taxonomy=$taxonomyCsv; no_fetch_boundary_checklist=$boundaryCsv; future_stage_option_matrix=$futureCsv; integration_readiness_notes=$integrationMd;
 git_repo_used=$true; git_commit_succeeded=$false; git_push_succeeded=$false; git_push_failure_note='pending'; head=$null; origin_main=$null; head_matches_origin=$false; worktree_clean=$false;
 next_safe_step='V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD'
}
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $latestPath -Encoding UTF8
@"
# V431A Local Footprint

Status: $status
Decision: $decision

Steam readonly universe/index planning package created. This is planning-only: no Steam/BUFF fetch, no market endpoint, no DATA_BRIDGE or active payload write, no EV calculation, no UI patch, no trade/order.

Recommended next safe step: V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD.

Report: $reportPath
Latest: $latestPath
Proof: $proof
"@ | Set-Content -LiteralPath $footprint -Encoding UTF8
@"
V431A git raw footprint
Stage: $StageName
Status: $status
Decision: $decision
Safe export: planning markdown, schema draft, taxonomy, boundary checklist, future stage matrix, integration notes, proof, report, footprint, git summaries.
Excluded: proprietary source mapping details, credentials/tokens/cookies/session/account data, UI source/backups, private workspace artifacts.
"@ | Set-Content -LiteralPath $gitRaw -Encoding UTF8
@"
# V431A Git Summary

Stage: $StageName
Status: $status
Decision: $decision

Steam readonly universe/index planning package created.

Safety summary: planning/package only. No UI patch, DATA_BRIDGE write, active payload write, Steam/BUFF fetch, market endpoint call, EV calculation, BUY/TRADE/ORDER, FAICTORY touch, reset, force push, deletion, or legacy/archive movement.

Next safe step: V431B_SCHEMA_ONLY_ARTIFACT_BUILD_OR_HOLD
"@ | Set-Content -LiteralPath $gitSummary -Encoding UTF8
'created V431A artifacts'
'RUN_DIR='+$RunDir
'REPORT='+$reportPath
'LATEST='+$latestPath
'PROOF='+$proof
'FOOTPRINT='+$footprint
'GIT_RAW='+$gitRaw
'GIT_SUMMARY='+$gitSummary

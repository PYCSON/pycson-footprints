# V431A Steam Readonly Universe / Index Planning

Stage: V431A_STEAM_READONLY_UNIVERSE_INDEX_PLANNING_OR_HOLD
Generated: 20260522_151910

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

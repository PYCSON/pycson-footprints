# V431L Candidate Screening Plan

Stage: V431L_CANDIDATE_SCREENING_PLAN_OR_HOLD
Generated: 20260523_080414

## Purpose

Future candidate screening classifies readonly or mock universe records into safe review categories. It is not a trading system, not an EV engine, and not a market fetch layer.

The screening layer should:
- classify records from schema/mock inputs,
- flag review-required items,
- identify mock/local candidate categories,
- prepare a future EV dryrun handoff only after explicit approval,
- never produce trade execution, order placement, or executable recommendation.

## Allowed Inputs

Allowed planning inputs:
- V431B schema-only artifacts,
- V431C local/mock universe fixture,
- V431D scheduler plan/state taxonomy,
- V431K accepted Steam workspace baseline.

Disallowed inputs at this stage:
- live market data,
- Steam fetch responses,
- BUFF fetch responses,
- account/session/cookie/token data,
- DATA_BRIDGE or active payload writes.

## Screening Approach

The first screening layer should be deterministic, local-only, and review-oriented:
- read mock/local records only in a future dryrun package,
- map candidate class and status based on safe metadata fields,
- emit review status and reason codes,
- keep NO_TRADE and NOT_SIGNAL_READY as explicit output states,
- reserve EV and trusted screening for later authorization stages.

## Forbidden Outputs

The screening plan must never output BUY_NOW, TRADEUP_NOW, executable ORDER, executable TRADE, executable profit signal, TRUSTED_EV, OFFICIAL_EV, or executable recommendation.

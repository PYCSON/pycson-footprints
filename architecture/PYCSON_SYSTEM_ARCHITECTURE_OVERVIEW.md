# PYCSON System Architecture Overview

Date: 20260513_195630

## 1. Data Layer
Reads local CSV, JSON, cache, price files, dashboard payloads, and candidate source files.

## 2. Rules Layer
Handles collection, rarity, trade-up rules, output pool, StatTrak separation, and float / wear ranges.

## 3. Calculation Layer
Handles probability, EV, ROI, fees, slippage, liquidity risk, stale price risk, and dryrun calculations.

## 4. Search Layer
Finds candidate combinations and market research opportunities.

## 5. Decision Layer
Outputs WATCH / REVIEW / SKIP / STRONG_WATCH. BUY_NOW and TRADEUP_NOW remain forbidden.

## 6. Display Layer
Shows validated research outputs in the V200 cockpit UI through controlled display gates.

## 7. Audit / Handoff Layer
Preserves report JSON, latest JSON, no-write proof, patch proof, footprint, handoff, rollback, and baseline snapshots.

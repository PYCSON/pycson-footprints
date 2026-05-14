# PYCSON Repository Structure Guide

This repository stores public-safe engineering footprints and summaries for the PYCSON project.

## Folder Map

### architecture/

Long-term system architecture documents.

Use this folder for:

- system layers
- non-trading research principles
- data/rule/calculation/risk/UI/audit architecture
- stable design explanations

This folder should not contain every small version footprint.

---

### git_summaries/

Small Git-facing summaries for regular development stages.

Use this folder for:

- one summary per meaningful code-delivery stage
- PASS/HOLD status
- next gate
- safety boundaries
- short engineering notes

This folder is more readable than raw footprints, but still technical.

---

### raw_footprints_archive/

Fine-grained engineering footprints.

Use this folder for:

- small version footprints
- raw/dev audit notes
- detailed stage traces
- machine-readable or AI-readable records
- proof that the system was built through many controlled gates

Example:

raw_footprints_archive/v430_pre_ev_chain/

This folder may be detailed and technical. It is not the main public showcase.

---

### milestone_summaries/

Human-readable milestone summaries.

Use this folder for:

- every ~10 versions
- every solved concrete problem
- every closed stage
- major route completion summaries

Examples:

- V429 big-loop closure
- V430 trusted price pool chain
- V430 pre-EV input chain
- future V500 signal loop alpha

---

### public_showcase/

Clean external-facing portfolio material.

Use this folder for:

- project overview
- business value
- system value
- architecture explained for outsiders
- readable progress summaries for friends, mentors, interviewers, or recruiters

This folder should stay clean and not be flooded with raw technical details.

---

### version_reports/

Version-chain reports and structured snapshots.

Use this folder for:

- stage-specific report summaries
- selected CSV snapshots
- latest-index snapshots
- organized version-chain artifacts

---

### version_summaries/

Version-range summaries.

Use this folder for:

- V430A-V430Q type summaries
- medium-level development history
- technical summaries that are more organized than raw footprints

---

### milestones/

Major named milestone folders.

Use this folder for:

- V429 big-loop closure
- V430 BUFF-first roadmap
- other named milestone packages

---

## Default PYCSON Footprint Rule

Every formal code-delivery stage should generate:

1. Local output directory under the PYCSON root.
2. Local footprint under:
   C:\Users\sunpu\Desktop\pycson\words.cossp
3. latest JSON under:
   C:\Users\sunpu\Desktop\pycson\11_SYSTEM_AUDIT_HANDOFF\99_AI_GENERATED_SYSTEM_INDEX
4. no-write proof.
5. handoff markdown.
6. legacy/new-chat handoff copy.
7. Git raw/dev footprint when useful.
8. Git summary when useful.
9. Milestone summary every ~10 versions or whenever a concrete problem/stage closes.

Small raw footprints and human-readable summaries should coexist.

Raw footprints prove audit depth.
Summaries explain value.
Public showcase explains the project to outsiders.

## Safety Boundary

Unless explicitly authorized and gated:

- no auto trade
- no auto order
- no BUY_NOW
- no TRADEUP_NOW
- no market fetch
- no BUFF fetch
- no DATA_BRIDGE write
- no active payload write
- no UI patch
- no official EV calculation

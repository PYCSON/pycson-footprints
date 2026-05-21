# V430PF Git Footprint Sync Repair Summary

The V430PF Git push was blocked because the unpushed footprint commit included a full LIVE UI backup inside the Git-side stage mirror. This repair excludes that full backup from Git scope and replaces it with safe metadata only.

Local backup preserved:
C:\Users\sunpu\Desktop\pycson\1060_V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD\V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD_20260521_141249\02_BACKUP\V200_MASTER_UI_LIVE_before_V430PF.html

Git-scope unsafe mirror backup:
stage_mirror/V430PF_LIVE_UI_SECOND_PASS_LIGHT_DECLUTTER_PATCH_EXECUTION_OR_HOLD_20260521_141249/02_BACKUP/V200_MASTER_UI_LIVE_before_V430PF.html

Repair action:
- Preserve local project backup.
- Remove full backup from Git tracking/scope only.
- Add metadata manifest with filename, local path, size, hash, created_at, purpose, and note that the full local backup is retained locally and not pushed to Git.
- Amend the unpushed V430PF footprint commit so history sent to GitHub no longer contains the full backup.

No reset, no clean, no force push, and no delete of local artifacts was performed.

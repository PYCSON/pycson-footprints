# V430OM LIVE UI Button Backup And Rollback Plan

## Backup Plan For V430ON
Before any later approved patch, copy V200_MASTER_UI_LIVE.html to a timestamped backup path under the V430ON stage folder.

## Rollback Plan
If V430ON review fails, restore the backed-up LIVE UI file over V200_MASTER_UI_LIVE.html using a non-destructive copy operation. Do not use git reset, git clean, git rm, force push, or deletion.

## Mother UI Protection
V200_MASTER_UI.html is read/hash-confirmed only and must remain unchanged.

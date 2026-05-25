# PYCSON Safe Git Export Helper

This helper is only a Git export finalizer for the PYCSON footprint repository.

Use it only after Codex has committed safe artifacts locally and says push/export is blocked or pending.

It does not:
- run PYCSON stages
- modify UI files
- write DATA_BRIDGE
- write active payload
- fetch Steam or BUFF
- call market endpoints
- calculate EV
- emit BUY/TRADE/ORDER actions
- run reset, git clean, force push, or delete files

Run `PYCSON_SAFE_PUSH_FINALIZE.cmd` to open the one-click PowerShell finalizer and keep the output visible.

The helper verifies the SSH remote, local SSH command, `core.longpaths`, clean worktree state, push result, fetch result, and `HEAD == origin/main` before printing `PASS`.

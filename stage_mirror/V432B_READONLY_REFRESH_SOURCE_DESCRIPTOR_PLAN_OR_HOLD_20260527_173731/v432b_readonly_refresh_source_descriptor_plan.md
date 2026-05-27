# V432B Readonly Refresh Source Descriptor Plan

Purpose: define the descriptor model needed before any future readonly refresh dryrun can safely refer to external or cached sources.

Accepted basis: V432A accepted the V431Y/V431Z readonly refresh dryrun milestone. That milestone proved local boundary/output dryrun capability but did not prove concrete source retrieval because no source descriptors were available.

Descriptor principles:
- Descriptors are declarations, not fetch instructions.
- A descriptor may define source identity, source category, trust label, access mode, freshness/staleness expectations, confidence fields, allowed output fields, and forbidden credentials/session/bypass fields.
- A descriptor must never contain credentials, cookies, tokens, captcha material, proxy credentials, account automation instructions, order/payment/wallet flows, DATA_BRIDGE targets, active payload paths, EV instructions, or BUY/TRADE/ORDER actions.

Connection to future readonly refresh dryrun:
- Future V432C/V432D work should review this plan before creating a source descriptor manifest package.
- A future manifest may be used by a readonly refresh dryrun only after review and explicit approval.
- EV remains blocked until descriptor, refresh-output mapping, and source freshness rules are accepted.

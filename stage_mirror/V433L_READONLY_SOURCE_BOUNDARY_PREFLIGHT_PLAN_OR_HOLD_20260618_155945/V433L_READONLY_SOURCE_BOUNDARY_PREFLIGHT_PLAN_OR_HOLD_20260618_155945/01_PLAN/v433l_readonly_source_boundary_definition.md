# Readonly Source Boundary Definition

Readonly source boundary means a future planning or dryrun stage may describe source classes and access assumptions, but must not fetch or call real source endpoints until a separate explicit approval-gated execution stage exists.

Closed boundaries:
- No login, cookies, captcha, proxy, bypass, browser session, or authenticated source access.
- No Steam fetch, BUFF fetch, market endpoint call, or external URL access in this stage.
- No readonly refresh execution.
- No DATA_BRIDGE or active payload write.
- No EV or trade/order output.

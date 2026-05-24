# No-Login / No-Cookie / No-Captcha / No-Proxy / No-Bypass Rules

Future readonly refresh work must not use or request:
- Account login.
- Session cookies.
- Stored credentials or tokens.
- Captcha solving.
- Proxy routing or proxy rotation.
- IP, region, account, or platform bypass behavior.
- Any mechanism intended to avoid platform controls.

If any future route requires one of these, STOP and request a new user decision packet.

# V430PYB User Screenshot Evidence Packet

Use this packet only if local browser automation remains unavailable.

## Start Local Server

`powershell
cd "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI"
python -m http.server 8899 --bind 127.0.0.1
`

If python is not on PATH, use the Codex bundled Python shown by the runtime dependency helper or open the HTML file directly in a browser as a local file.

## Open Target

http://127.0.0.1:8899/V200_MASTER_UI_LIVE.html

## Required Screenshots

Capture screenshots showing:

1. Full page top area.
2. Left Route Directory / navigation area.
3. Center active route / Steam Mature Loop area.
4. Right review/risk panel.
5. Bottom safety/audit dock.
6. Theme/color controls.
7. V430PT readonly status display showing:
   - REVIEW_REQUIRED / PARTIAL_SCREENING
   - 7/7 refresh success
   - 7 price candidates
   - 0 blocked
   - 0 errors
   - 0 screening-ready
   - 7 hold/review

Save screenshots locally only unless user explicitly approves export.

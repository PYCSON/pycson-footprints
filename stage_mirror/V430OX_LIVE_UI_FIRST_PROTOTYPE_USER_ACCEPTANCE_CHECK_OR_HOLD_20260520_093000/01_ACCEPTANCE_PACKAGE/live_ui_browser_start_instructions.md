# V430OX LIVE UI Browser Start Instructions

Open PowerShell and run:

```powershell
cd "C:\Users\sunpu\Desktop\pycson\02_UI_SYSTEMS\PYCSON_MASTER_UI"
python -m http.server 8899 --bind 127.0.0.1
```

Then open this URL in a browser:

http://127.0.0.1:8899/V200_MASTER_UI_LIVE.html

Acceptance note: this local server is only for viewing static LIVE UI files. Do not perform Steam fetch, BUFF fetch, EV calculation, DATA_BRIDGE write, active payload write, BUY_NOW, TRADEUP_NOW, or trade/order actions during this acceptance check.

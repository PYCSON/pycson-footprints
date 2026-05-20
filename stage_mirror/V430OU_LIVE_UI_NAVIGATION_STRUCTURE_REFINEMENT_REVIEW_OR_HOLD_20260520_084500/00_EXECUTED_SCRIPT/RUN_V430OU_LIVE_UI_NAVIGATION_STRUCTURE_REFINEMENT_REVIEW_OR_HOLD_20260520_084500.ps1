# V430OU executed script record
$ProjectRoot = 'C:\Users\sunpu\Desktop\pycson'
$LiveUi = Join-Path $ProjectRoot '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI_LIVE.html'
$MotherUi = Join-Path $ProjectRoot '02_UI_SYSTEMS\PYCSON_MASTER_UI\V200_MASTER_UI.html'
Get-FileHash -Algorithm SHA256 -LiteralPath $MotherUi
Get-FileHash -Algorithm SHA256 -LiteralPath $LiveUi
Select-String -LiteralPath $LiveUi -Pattern 'pycson-v430ot-route-directory','data-v430ot-route','pycson-v430oi-steam-mature-loop-readonly','pycson-v430on-steam-mature-loop-entry'

# Requires -RunAsAdministrator
$url = "https://github.com/clickinformaticavillaramallo/anydesk/raw/main/AnyDesk.exe"
$out = "$env:TEMP\AnyDesk.exe"

Write-Host "Descargando AnyDesk..." -ForegroundColor Green
Invoke-WebRequest $url -OutFile $out

Write-Host "Instalando AnyDesk (silencioso)..." -ForegroundColor Yellow
Start-Process $out -Args "--install `"$env:ProgramFiles\AnyDesk`" --start-with-win --create-shortcuts --silent" -Wait

Write-Host "AnyDesk listo." -ForegroundColor Green
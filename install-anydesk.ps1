<#  install-anydesk.ps1
    Descarga e instala AnyDesk en modo desatendido.
    Requisito: PowerShell 5.1+ con permisos de administrador.
#>

#Requires -Version 5.1
param()

# ---------- Comprobar ejecución como admin ----------------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Error "Este script debe ejecutarse como Administrador. Ejemplo: powershell -ep bypass -File install-anydesk.ps1"
    exit 1
}

# ---------- Configuración ---------------------------------------------------
$downloadUrl = "https://github.com/clickinformaticavillaramallo/anydesk/raw/main/AnyDesk.exe"
$installer   = "$env:TEMP\AnyDesk.exe"
$installPath = "$env:ProgramFiles\AnyDesk"

# ---------- Descarga --------------------------------------------------------
Write-Host "[*] Descargando AnyDesk..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installer -UseBasicParsing
} catch {
    Write-Error "No se pudo descargar AnyDesk: $($_.Exception.Message)"
    exit 2
}

if (-not (Test-Path $installer)) {
    Write-Error "El instalador no se encontró tras la descarga."
    exit 3
}

# ---------- Instalación silenciosa ------------------------------------------
Write-Host "[*] Instalando AnyDesk (modo silencioso)..." -ForegroundColor Yellow
$proc = Start-Process -FilePath $installer `
                      -ArgumentList "--install `"$installPath`"",
                                     "--start-with-win",
                                     "--create-shortcuts",
                                     "--silent" `
                      -PassThru -Wait

if ($proc.ExitCode -ne 0) {
    Write-Error "La instalación finalizó con código $($proc.ExitCode)."
    exit 4
}

# ---------- Verificación ----------------------------------------------------
if (Test-Path "$installPath\AnyDesk.exe") {
    Write-Host "[+] AnyDesk instalado correctamente." -ForegroundColor Green
} else {
    Write-Error "AnyDesk no se encontró en la ruta esperada."
    exit 5
}

# ---------- Limpieza --------------------------------------------------------
Remove-Item $installer -Force -ErrorAction SilentlyContinue
exit 0

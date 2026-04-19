param(
    [string]$InstallRoot = "C:\Program Files (x86)\PIME"
)

$ErrorActionPreference = "Stop"

function Assert-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "Please run this script from an elevated PowerShell session."
    }
}

Assert-Admin

$launcherExe = Join-Path $InstallRoot "PIMELauncher.exe"
$x64Dll = Join-Path $InstallRoot "x64\PIMETextService.dll"
$x86Dll = Join-Path $InstallRoot "x86\PIMETextService.dll"

Write-Host "Stopping PIMELauncher if it is running..."
if (Test-Path -LiteralPath $launcherExe) {
    & $launcherExe /quit | Out-Null
    Start-Sleep -Seconds 1
}

Write-Host "Unregistering text service DLLs..."
if (Test-Path -LiteralPath $x64Dll) {
    & "$env:WINDIR\System32\regsvr32.exe" /u /s $x64Dll
}
if (Test-Path -LiteralPath $x86Dll) {
    & "$env:WINDIR\SysWOW64\regsvr32.exe" /u /s $x86Dll
}

Write-Host "Removing launcher autorun and install markers..."
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "PIMELauncher" -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\PIME" -Recurse -Force -ErrorAction SilentlyContinue

if (Test-Path -LiteralPath $InstallRoot) {
    Write-Host "Removing installation tree $InstallRoot"
    Remove-Item -LiteralPath $InstallRoot -Recurse -Force
}

Write-Host "Developer uninstall completed."

param(
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot),
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

function Assert-PathExists {
    param(
        [string]$Path,
        [string]$Description
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Description not found: $Path"
    }
}

function Copy-Tree {
    param(
        [string]$Source,
        [string]$Destination,
        [string[]]$ExcludeDirs = @(),
        [string[]]$ExcludeFiles = @()
    )

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null

    $robocopyArgs = @(
        $Source,
        $Destination,
        "/MIR",
        "/R:1",
        "/W:1",
        "/NFL",
        "/NDL",
        "/NJH",
        "/NJS",
        "/NP"
    )

    if ($ExcludeDirs.Count -gt 0) {
        $robocopyArgs += "/XD"
        $robocopyArgs += $ExcludeDirs
    }
    if ($ExcludeFiles.Count -gt 0) {
        $robocopyArgs += "/XF"
        $robocopyArgs += $ExcludeFiles
    }

    & robocopy @robocopyArgs | Out-Null
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy failed for $Source -> $Destination with exit code $LASTEXITCODE"
    }
}

Assert-Admin

$repoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$buildRoot = Join-Path $repoRoot "build"
$build64Root = Join-Path $repoRoot "build64"
$launcherExe = Join-Path $buildRoot "PIMELauncher\Release\PIMELauncher.exe"
$x86Dll = Join-Path $buildRoot "PIMETextService\Release\PIMETextService.dll"
$x64Dll = Join-Path $build64Root "PIMETextService\Release\PIMETextService.dll"
$versionFile = Join-Path $repoRoot "version.txt"
$backendsFile = Join-Path $repoRoot "backends.json"
$pythonRoot = Join-Path $repoRoot "python"
$nodeRoot = Join-Path $repoRoot "node"

Assert-PathExists -Path $launcherExe -Description "Win32 PIMELauncher"
Assert-PathExists -Path $x86Dll -Description "Win32 PIMETextService.dll"
Assert-PathExists -Path $x64Dll -Description "x64 PIMETextService.dll"
Assert-PathExists -Path $versionFile -Description "version.txt"
Assert-PathExists -Path $backendsFile -Description "backends.json"
Assert-PathExists -Path (Join-Path $pythonRoot "python3\python.exe") -Description "bundled Python runtime"
Assert-PathExists -Path (Join-Path $nodeRoot "node.exe") -Description "bundled Node runtime"

Write-Host "Stopping any running PIMELauncher instance..."
$installedLauncher = Join-Path $InstallRoot "PIMELauncher.exe"
if (Test-Path -LiteralPath $installedLauncher) {
    & $installedLauncher /quit | Out-Null
    Start-Sleep -Seconds 1
}

Write-Host "Creating installation layout at $InstallRoot"
New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $InstallRoot "x86") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $InstallRoot "x64") -Force | Out-Null

Copy-Item -LiteralPath $versionFile -Destination (Join-Path $InstallRoot "version.txt") -Force
Copy-Item -LiteralPath $backendsFile -Destination (Join-Path $InstallRoot "backends.json") -Force
Copy-Item -LiteralPath $launcherExe -Destination (Join-Path $InstallRoot "PIMELauncher.exe") -Force
Copy-Item -LiteralPath $x86Dll -Destination (Join-Path $InstallRoot "x86\PIMETextService.dll") -Force
Copy-Item -LiteralPath $x64Dll -Destination (Join-Path $InstallRoot "x64\PIMETextService.dll") -Force

Write-Host "Copying Python backend..."
Copy-Tree -Source $pythonRoot -Destination (Join-Path $InstallRoot "python") -ExcludeDirs @("__pycache__")

Write-Host "Copying Node backend..."
Copy-Tree -Source $nodeRoot -Destination (Join-Path $InstallRoot "node") -ExcludeDirs @("node_modules\.cache")

Write-Host "Registering text service DLLs..."
& "$env:WINDIR\System32\regsvr32.exe" /s (Join-Path $InstallRoot "x64\PIMETextService.dll")
& "$env:WINDIR\SysWOW64\regsvr32.exe" /s (Join-Path $InstallRoot "x86\PIMETextService.dll")

Write-Host "Writing launcher autorun and install markers..."
New-Item -Path "HKLM:\SOFTWARE\PIME" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\PIME" -Name "(default)" -Value $InstallRoot
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "PIMELauncher" -Value (Join-Path $InstallRoot "PIMELauncher.exe")

Write-Host "Starting PIMELauncher..."
Start-Process -FilePath (Join-Path $InstallRoot "PIMELauncher.exe")

Write-Host "Developer install completed: $InstallRoot"

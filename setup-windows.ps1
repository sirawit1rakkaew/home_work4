<#
PowerShell helper to prepare a Windows system for running the toy_app Rails project.

Usage (run as Administrator):
  Open PowerShell as Administrator and run:
    powershell -ExecutionPolicy Bypass -File .\toy_app\setup-windows.ps1

This script will:
- Optionally install Chocolatey (if missing)
- Install Git, Ruby, Node.js (LTS), and SQLite via Chocolatey
- Install Bundler and Rails gems
- Run `bundle install`, `rails db:setup` inside the repository
- Start the Rails server (binds to 0.0.0.0:3000)

NOTE: Installing system packages requires Administrator privileges and may be
interactive. If you prefer manual installs, follow the README.md instead.
#>

function Assert-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Error 'This script must be run as Administrator. Right-click PowerShell and choose "Run as administrator".'
        exit 1
    }
}

function Install-ChocoIfMissing {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host 'Chocolatey not found — installing Chocolatey (requires network and Admin)...'
        Set-ExecutionPolicy Bypass -Scope Process -Force
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Error 'Chocolatey installation failed. Install Chocolatey manually: https://chocolatey.org/install'
            exit 1
        }
    }
}

function Install-PackagesWithChoco {
    param(
        [string[]] $packages
    )
    foreach ($pkg in $packages) {
        Write-Host "Installing $pkg via choco..."
        choco install $pkg -y --no-progress
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "choco install $pkg returned non-zero exit code ($LASTEXITCODE). You may need to retry manually."
        }
    }
    # Refresh environment variables set by chocolatey
    cmd /c refreshenv | Out-Null
}

function Ensure-Gems {
    Write-Host 'Installing Bundler and Rails gems (may take some time)...'
    gem install bundler --no-document
    if ($LASTEXITCODE -ne 0) { Write-Warning 'gem install bundler failed.' }
    gem install rails --no-document
    if ($LASTEXITCODE -ne 0) { Write-Warning 'gem install rails failed.' }
}

function Run-AppSetupAndServer {
    param([string]$repoPath)
    Push-Location $repoPath
    try {
        Write-Host 'Running bundle install...'
        bundle install --jobs 4
        if ($LASTEXITCODE -ne 0) { Write-Warning 'bundle install returned non-zero exit code.' }

        Write-Host 'Setting up the database (rails db:setup)...'
        rails db:setup
        if ($LASTEXITCODE -ne 0) { Write-Warning 'rails db:setup returned non-zero exit code.' }

        Write-Host 'Starting Rails server on 0.0.0.0:3000 (press Ctrl+C to stop)...'
        rails server -b 0.0.0.0
    }
    finally { Pop-Location }
}

### Main
Assert-Admin

Write-Host 'This script will attempt to install system dependencies and run the app.' -ForegroundColor Cyan
Write-Host 'Press ENTER to continue or CTRL+C to abort.'
Read-Host | Out-Null

Install-ChocoIfMissing

$pkgs = @('git','nodejs-lts','sqlite','ruby')
Install-PackagesWithChoco -packages $pkgs

Ensure-Gems

# Path to the repository (assumes script is run from parent folder of toy_app or higher)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoPath = Join-Path $scriptDir 'toy_app'
if (-not (Test-Path $repoPath)) {
    # If script was invoked from repository root, repo path may be ./
    $repoPath = Join-Path (Get-Location) 'toy_app'
}

if (-not (Test-Path $repoPath)) {
    Write-Error "Cannot find toy_app folder at expected path: $repoPath. Run this script from the parent folder of toy_app."
    exit 1
}

Run-AppSetupAndServer -repoPath $repoPath

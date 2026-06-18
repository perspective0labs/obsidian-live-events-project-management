# Obsidian Live Events Project Management — Plugin Installer (Windows)
$ErrorActionPreference = "Stop"

$Repo    = "perspective0labs/obsidian-live-events-project-management"
$Raw     = "https://raw.githubusercontent.com/$Repo/main/plugins"
$Plugins = @("obsidian-mastertour", "obsidian-google-workspace", "obsidian-google-chat")

Write-Host ""
Write-Host "Obsidian Live Events Project Management"
Write-Host "Plugin Installer — Windows"
Write-Host "======================================="
Write-Host ""

$DefaultVault = "$env:USERPROFILE\Documents\Obsidian"
Write-Host "Enter the full path to your Obsidian vault."
Write-Host "Press Enter to use: $DefaultVault"
$VaultPath = Read-Host "Vault path"
if (-not $VaultPath) { $VaultPath = $DefaultVault }

if (-not (Test-Path $VaultPath)) {
    Write-Host "ERROR: Vault not found at $VaultPath" -ForegroundColor Red
    Write-Host "Create the folder first then re-run this script."
    exit 1
}

$PluginsDir = "$VaultPath\.obsidian\plugins"
New-Item -ItemType Directory -Force -Path $PluginsDir | Out-Null

Write-Host ""
foreach ($Plugin in $Plugins) {
    Write-Host "Installing $Plugin..."
    $Dir = "$PluginsDir\$Plugin"
    New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    Invoke-WebRequest "$Raw/$Plugin/main.js"       -OutFile "$Dir\main.js"
    Invoke-WebRequest "$Raw/$Plugin/styles.css"    -OutFile "$Dir\styles.css"
    Invoke-WebRequest "$Raw/$Plugin/manifest.json" -OutFile "$Dir\manifest.json"
    Write-Host "  OK $Plugin" -ForegroundColor Green
}

Write-Host ""
Write-Host "All plugins installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open Obsidian and select your vault at: $VaultPath"
Write-Host "  2. Go to Settings -> Community Plugins -> turn off Restricted Mode"
Write-Host "  3. Enable: Mastertour, Google Workspace, Google Chat"
Write-Host "  4. Configure each plugin with your API credentials in Settings"
Write-Host ""

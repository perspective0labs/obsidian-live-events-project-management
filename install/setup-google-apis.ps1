# Obsidian Live Events — Google Cloud API setup for Google Workspace & Google Chat plugins
#
# Automates everything gcloud CAN automate: project creation and API enablement.
# OAuth consent screen + OAuth Client ID creation must be done once in the Cloud
# Console UI — Google does not expose a public API for those two steps.
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Obsidian Live Events — Google API Setup"
Write-Host "========================================"
Write-Host ""

if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: gcloud CLI not found." -ForegroundColor Red
    Write-Host "Install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
}

$Account = (gcloud config get-value account 2>$null)
if (-not $Account -or $Account -eq "(unset)") {
    Write-Host "You're not logged in to gcloud. Running 'gcloud auth login'..."
    gcloud auth login
}

Write-Host ""
Write-Host "Logged in as: $(gcloud config get-value account)"
Write-Host ""

$DefaultProjectId = "obsidian-live-events-$(Get-Random -Maximum 99999)"
Write-Host "Enter a Google Cloud project ID to create (lowercase, no spaces)."
Write-Host "Press Enter to use: $DefaultProjectId"
$ProjectId = Read-Host "Project ID"
if (-not $ProjectId) { $ProjectId = $DefaultProjectId }

Write-Host ""
Write-Host "Creating project: $ProjectId..."
try {
    gcloud projects create $ProjectId --name="Obsidian Live Events"
} catch {
    Write-Host "Project may already exist — continuing with it."
}

gcloud config set project $ProjectId

Write-Host ""
Write-Host "Enabling required APIs..."
gcloud services enable drive.googleapis.com chat.googleapis.com people.googleapis.com --project=$ProjectId

Write-Host ""
Write-Host "APIs enabled: Drive, Chat, People" -ForegroundColor Green
Write-Host ""
Write-Host "=========================================================================="
Write-Host "MANUAL STEPS REQUIRED (Google does not allow API automation of these two):"
Write-Host "=========================================================================="
Write-Host ""
Write-Host "1. OAuth consent screen:"
Write-Host "   https://console.cloud.google.com/apis/credentials/consent?project=$ProjectId"
Write-Host ""
Write-Host "   - User type: Internal (Workspace org) or External"
Write-Host "   - Add these scopes:"
Write-Host "       https://www.googleapis.com/auth/drive"
Write-Host "       https://www.googleapis.com/auth/chat.messages"
Write-Host "       https://www.googleapis.com/auth/chat.spaces.readonly"
Write-Host "       https://www.googleapis.com/auth/chat.memberships"
Write-Host "       https://www.googleapis.com/auth/contacts.readonly"
Write-Host "       https://www.googleapis.com/auth/userinfo.profile"
Write-Host "   - If External, add yourself + colleagues as test users"
Write-Host ""
Write-Host "2. Create OAuth Client ID:"
Write-Host "   https://console.cloud.google.com/apis/credentials?project=$ProjectId"
Write-Host ""
Write-Host "   - Create Credentials -> OAuth client ID"
Write-Host "   - Application type: Desktop app"
Write-Host "   - Copy the Client ID and Client Secret it gives you"
Write-Host ""
Write-Host "3. Paste that Client ID + Secret into:"
Write-Host "   Obsidian -> Settings -> Google Workspace"
Write-Host "   Obsidian -> Settings -> Google Chat"
Write-Host "   (same credentials work for both plugins)"
Write-Host ""
Write-Host "Opening the consent screen page in your browser now..."
Start-Process "https://console.cloud.google.com/apis/credentials/consent?project=$ProjectId"

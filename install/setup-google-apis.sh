#!/usr/bin/env bash
# Obsidian Live Events — Google Cloud API setup for Google Workspace & Google Chat plugins
#
# Automates everything gcloud CAN automate: project creation and API enablement.
# OAuth consent screen + OAuth Client ID creation must be done once in the Cloud
# Console UI — Google does not expose a public API for those two steps.
set -e

echo ""
echo "Obsidian Live Events — Google API Setup"
echo "========================================"
echo ""

if ! command -v gcloud &> /dev/null; then
  echo "ERROR: gcloud CLI not found."
  echo "Install it from: https://cloud.google.com/sdk/docs/install"
  exit 1
fi

# Confirm logged in
ACCOUNT=$(gcloud config get-value account 2>/dev/null || true)
if [ -z "$ACCOUNT" ] || [ "$ACCOUNT" == "(unset)" ]; then
  echo "You're not logged in to gcloud. Running 'gcloud auth login'..."
  gcloud auth login
fi

echo ""
echo "Logged in as: $(gcloud config get-value account)"
echo ""

# Project
DEFAULT_PROJECT_ID="obsidian-live-events-$(date +%s | tail -c 6)"
echo "Enter a Google Cloud project ID to create (lowercase, no spaces)."
echo "Press Enter to use: $DEFAULT_PROJECT_ID"
read -r PROJECT_ID
PROJECT_ID="${PROJECT_ID:-$DEFAULT_PROJECT_ID}"

echo ""
echo "Creating project: $PROJECT_ID..."
gcloud projects create "$PROJECT_ID" --name="Obsidian Live Events" || {
  echo "Project may already exist — continuing with it."
}

gcloud config set project "$PROJECT_ID"

# Billing note: Drive/Chat/People APIs don't require billing for this usage,
# but some orgs enforce a billing account on all projects. Skip silently if not linked.

echo ""
echo "Enabling required APIs..."
gcloud services enable \
  drive.googleapis.com \
  chat.googleapis.com \
  people.googleapis.com \
  --project="$PROJECT_ID"

echo ""
echo "APIs enabled: Drive, Chat, People"
echo ""
echo "=========================================================================="
echo "MANUAL STEPS REQUIRED (Google does not allow API automation of these two):"
echo "=========================================================================="
echo ""
echo "1. OAuth consent screen:"
echo "   https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
echo ""
echo "   - User type: Internal (Workspace org) or External"
echo "   - Add these scopes:"
echo "       https://www.googleapis.com/auth/drive"
echo "       https://www.googleapis.com/auth/chat.messages"
echo "       https://www.googleapis.com/auth/chat.spaces.readonly"
echo "       https://www.googleapis.com/auth/chat.memberships"
echo "       https://www.googleapis.com/auth/contacts.readonly"
echo "       https://www.googleapis.com/auth/userinfo.profile"
echo "   - If External, add yourself + colleagues as test users"
echo ""
echo "2. Create OAuth Client ID:"
echo "   https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
echo ""
echo "   - Create Credentials -> OAuth client ID"
echo "   - Application type: Desktop app"
echo "   - Copy the Client ID and Client Secret it gives you"
echo ""
echo "3. Paste that Client ID + Secret into:"
echo "   Obsidian -> Settings -> Google Workspace"
echo "   Obsidian -> Settings -> Google Chat"
echo "   (same credentials work for both plugins)"
echo ""
echo "Opening the consent screen and credentials pages in your browser now..."
echo ""

if command -v open &> /dev/null; then
  open "https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
elif command -v xdg-open &> /dev/null; then
  xdg-open "https://console.cloud.google.com/apis/credentials/consent?project=$PROJECT_ID"
fi

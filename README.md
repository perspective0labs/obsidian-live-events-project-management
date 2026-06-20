# Obsidian Live Events Project Management

A toolkit for live event professionals using [Obsidian](https://obsidian.md) — connecting Mastertour, Google Workspace, and Google Chat directly inside your notes.

## Included Plugins

| Plugin | Description |
|--------|-------------|
| **Mastertour** | Browse tours, view daily schedules, venue info, advances, and crew. Export days to calendar or email. |
| **Google Workspace** | Access Google Drive, Docs, Sheets, and Slides from inside Obsidian. |
| **Google Chat** | Read and send Google Chat messages without leaving your notes. |
| **Claude Desktop Mirror** | Mirror Claude Desktop conversations and context into your Obsidian vault. |

## Quick Install

### macOS
Open Terminal and run:
```bash
curl -sL https://raw.githubusercontent.com/perspective0labs/obsidian-live-events-project-management/main/install/install-mac.sh | bash
```

### Windows
Open PowerShell and run:
```powershell
irm https://raw.githubusercontent.com/perspective0labs/obsidian-live-events-project-management/main/install/install-windows.ps1 | iex
```

The installer will ask for your vault path and install all three plugins automatically.

## Manual Install

1. Download the plugin files from the `plugins/` folder
2. Copy each plugin folder to `<your vault>/.obsidian/plugins/`
3. Restart Obsidian
4. Go to **Settings → Community Plugins** → turn off Restricted Mode → enable each plugin

## Setup After Installing

### Mastertour
- Go to **Settings → Mastertour**
- Enter your **Consumer Key** and **Consumer Secret** from [my.eventric.com](https://my.eventric.com)

### Google Workspace & Google Chat
These two plugins need a Google Cloud project with a few APIs enabled and an OAuth Client ID.

**Important:** Google does not allow the OAuth consent screen or OAuth Client ID to be created via script — that step **must** be done manually, once, in the Cloud Console. Do that first, then run the script to enable the required APIs.

Full walkthrough: **[GOOGLE_API_SETUP.md](GOOGLE_API_SETUP.md)**

Quick version:
1. **Manually configure** the OAuth consent screen and create an OAuth Client ID (Desktop app type) in [Google Cloud Console](https://console.cloud.google.com/apis/credentials) — see GOOGLE_API_SETUP.md for exact scopes and steps
2. **Then run the script** to create the project and enable the required APIs (Drive, Chat, People):

   ```bash
   curl -sL https://raw.githubusercontent.com/perspective0labs/obsidian-live-events-project-management/main/install/setup-google-apis.sh | bash
   ```

   (Windows: `install/setup-google-apis.ps1`)

3. Go to **Settings → Google Workspace** / **Google Chat** in Obsidian and paste in the Client ID + Client Secret from step 1

## Workspaces

The `workspaces/` folder contains pre-configured Obsidian workspace layouts. To use them:
1. Copy `workspace.json` and `workspaces.json` to `<your vault>/.obsidian/`
2. Restart Obsidian

## Requirements

- [Obsidian](https://obsidian.md) v1.4.0 or later
- A [Mastertour](https://www.eventric.com/mastertour/) account with API access
- A Google account (for Workspace and Chat plugins)

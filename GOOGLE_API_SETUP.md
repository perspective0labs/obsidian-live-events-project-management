# Google API Setup — Google Workspace & Google Chat Plugins

Both the **Google Workspace** and **Google Chat** plugins authenticate with your own Google Cloud project using OAuth 2.0 (loopback flow, `redirect_uri: http://localhost`). You need to create that project once and generate a Client ID + Client Secret.

You can do this two ways: the automated script below, or the manual steps further down.

## Option A — Automated Script (recommended)

Requires the [`gcloud` CLI](https://cloud.google.com/sdk/docs/install) installed and logged in (`gcloud auth login`).

```bash
curl -sL https://raw.githubusercontent.com/perspective0labs/obsidian-live-events-project-management/main/install/setup-google-apis.sh | bash
```

This will:
1. Create a new Google Cloud project (or use one you specify)
2. Enable the required APIs (Drive, Chat, People)
3. Walk you through creating the OAuth consent screen and OAuth Client ID (these two steps require the Cloud Console UI — Google does not allow full API automation of OAuth client/consent screen creation)
4. Print the Client ID and Client Secret to paste into each plugin's settings

## Option B — Manual Setup

### 1. Create a Google Cloud Project
1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Click the project dropdown → **New Project**
3. Name it (e.g. `obsidian-live-events`) → **Create**

### 2. Enable Required APIs
In your new project, go to **APIs & Services → Library** and enable:

| API | Needed for |
|-----|-------------|
| **Google Drive API** | Google Workspace plugin (Drive/Docs/Sheets/Slides file access) |
| **Google Chat API** | Google Chat plugin |
| **People API** | Both plugins (contacts lookup) |

Direct links (replace `PROJECT_ID` with your project):
- `https://console.cloud.google.com/apis/library/drive.googleapis.com?project=PROJECT_ID`
- `https://console.cloud.google.com/apis/library/chat.googleapis.com?project=PROJECT_ID`
- `https://console.cloud.google.com/apis/library/people.googleapis.com?project=PROJECT_ID`

### 3. Configure OAuth Consent Screen
1. Go to **APIs & Services → OAuth consent screen**
2. User type: **Internal** (if using Google Workspace org) or **External**
3. Fill in app name, support email
4. Add scopes:
   - `https://www.googleapis.com/auth/drive`
   - `https://www.googleapis.com/auth/chat.messages`
   - `https://www.googleapis.com/auth/chat.spaces.readonly`
   - `https://www.googleapis.com/auth/chat.memberships`
   - `https://www.googleapis.com/auth/contacts.readonly`
   - `https://www.googleapis.com/auth/userinfo.profile`
5. If **External**, add yourself and colleagues as test users (or publish the app if you want anyone to use it without the "unverified app" warning)

### 4. Create OAuth Client ID
1. Go to **APIs & Services → Credentials → Create Credentials → OAuth client ID**
2. Application type: **Desktop app**
3. Name it (e.g. `Obsidian Plugin`)
4. Click **Create** — copy the **Client ID** and **Client Secret**

### 5. Configure the Plugins
In Obsidian:
1. **Settings → Google Workspace** → paste Client ID + Client Secret → click **Sign in with Google**
2. **Settings → Google Chat** → paste Client ID + Client Secret → click **Sign in with Google**

(You can reuse the same OAuth Client ID/Secret for both plugins since they request overlapping scopes.)

## Troubleshooting

- **"This app isn't verified"** — expected for External apps that haven't been through Google's verification. Click **Advanced → Go to [app name] (unsafe)** to proceed. This is safe since it's your own Cloud project.
- **403 / access denied on Chat API calls** — make sure the signed-in account is a member of the Chat spaces you're trying to access.
- **Token expired / re-auth loop** — click sign-out then sign-in again in the plugin settings to get a fresh refresh token.

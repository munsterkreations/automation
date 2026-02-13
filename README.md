# Setup Guide

## Quick Start

### 1. Install Dependencies

```bash
bundle install
```

### 2. Get YouTube API Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the YouTube Data API v3
4. Create OAuth 2.0 credentials (Desktop application)
5. Download the credentials JSON file
6. Save it as `credentials.json` in the project root

### 3. Authenticate

Run the authentication command first:

```bash
ruby main.rb auth
```

This will:
- Open your browser for OAuth authorization
- Save your token to `token.json`
- Allow subsequent commands to work without re-authentication

### 4. Upload a Video

```bash
ruby main.rb upload --file path/to/video.mp4 --title "My Video" --description "Video description"
```

### 5. Create a Playlist

```bash
ruby main.rb playlist --title "My Playlist" --description "Playlist description"
```

## Using the CLI Executable

After installing the gem, you can also use:

```bash
./exe/cli auth
./exe/cli upload -f video.mp4 -t "Title"
./exe/cli playlist -t "Playlist Name"
```

## File Structure

- `main.rb` - Main entry point for running the automation
- `exe/cli` - Executable CLI wrapper
- `lib/automation.rb` - Core automation library
- `lib/oauth_util.rb` - OAuth authentication helper
- `credentials.json` - Your Google API credentials (not in repo)
- `token.json` - Your OAuth token (generated after auth, not in repo)

## Troubleshooting

### Missing credentials.json
Download your OAuth credentials from Google Cloud Console and save as `credentials.json`

### Authentication fails
1. Make sure `credentials.json` is in the project root
2. Check that the redirect URI in your Google Cloud Console matches `http://localhost:8080`
3. Delete `token.json` and re-run `ruby main.rb auth`

### Upload fails
1. Ensure you've authenticated first with `ruby main.rb auth`
2. Check that your video file exists and is a valid format
3. Verify your YouTube API quota hasn't been exceeded

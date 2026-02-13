# Quick Start Guide

## Installation (3 steps)

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Get Google credentials:**
   - Visit: https://console.cloud.google.com/
   - Enable YouTube Data API v3
   - Create OAuth 2.0 credentials (Desktop app)
   - Download as `credentials.json` → save in project root

3. **Authenticate:**
   ```bash
   ruby main.rb auth
   ```

## Usage

### Upload a video
```bash
ruby main.rb upload --file video.mp4 --title "My Video" --description "Description"
```

### Create a playlist
```bash
ruby main.rb playlist --title "My Playlist" --description "Description"
```

### Full options
```bash
# Upload with all options
ruby main.rb upload \
  --file video.mp4 \
  --title "My Video" \
  --description "Description" \
  --privacy public \
  --category 22 \
  --keywords "tag1,tag2,tag3"

# Create playlist with privacy
ruby main.rb playlist \
  --title "My Playlist" \
  --description "Description" \
  --privacy private
```

## Alternative: Use CLI executable

```bash
./exe/cli auth
./exe/cli upload -f video.mp4 -t "Title"
./exe/cli playlist -t "Playlist"
```

That's it! 🚀

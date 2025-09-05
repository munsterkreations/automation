#!/usr/bin/env ruby

require "google/apis/youtube_v3"
require "signet/oauth_2/client"
require "json"
require "optparse"
require "launchy"
require "webrick"

# ---- CONFIG ----
OOB_URI = "http://localhost:8080"
CREDENTIALS_FILE = "credentials.json" # from Google Cloud Console
TOKEN_FILE = "token.json"
SCOPE = "https://www.googleapis.com/auth/youtube.upload"

# ---- AUTH HELPER ----
def authorize
  credentials = JSON.parse(File.read(CREDENTIALS_FILE))["installed"]

  client = Signet::OAuth2::Client.new(
    client_id: credentials["client_id"],
    client_secret: credentials["client_secret"],
    authorization_uri: "https://accounts.google.com/o/oauth2/auth",
    token_credential_uri: "https://oauth2.googleapis.com/token",
    redirect_uri: credentials["redirect_uris"].first,
    scope: SCOPE
  )

  if File.exist?(TOKEN_FILE)
    token_data = JSON.parse(File.read(TOKEN_FILE))
    client.update_token!(token_data)
    if client.expired?
      client.fetch_access_token!
      save_token(client)
    end
  else
    # Local server flow
    server = WEBrick::HTTPServer.new(
      Port: 8080,
      Logger: WEBrick::Log.new(File::NULL),
      AccessLog: []
    )

    server.mount_proc "/" do |req, res|
      client.code = req.query["code"]
      client.fetch_access_token!
      save_token(client)
      res.body = "<h3>✅ Auth complete, you can close this window.</h3>"
      server.shutdown
    end

    Launchy.open(client.authorization_uri.to_s)
    trap("INT") { server.shutdown }
    server.start
  end

  client
end

def save_token(client)
  File.open(TOKEN_FILE, "w", 0600) do |file|
    file.write(JSON.pretty_generate(client.to_h))
  end
end

# ---- CLI OPTIONS ----
options = {
  title: "Test Title",
  description: "Test Description",
  category_id: "22",
  keywords: "",
  privacy_status: "public"
}

OptionParser.new do |opts|
  opts.banner = "Usage: uploader.rb [options]"

  opts.on("-f", "--file FILE", "Video file to upload") { |v| options[:file] = v }
  opts.on("-t", "--title TITLE", "Video title") { |v| options[:title] = v }
  opts.on("-d", "--description DESC", "Video description") { |v| options[:description] = v }
  opts.on("-c", "--category ID", "Category ID") { |v| options[:category_id] = v }
  opts.on("-k", "--keywords x,y,z", "Keywords (comma-separated)") { |v| options[:keywords] = v }
  opts.on("-p", "--privacy STATUS", "Privacy: public|private|unlisted") { |v| options[:privacy_status] = v }
end.parse!

abort("❌ Must specify --file") unless options[:file] && File.file?(options[:file])

# ---- MAIN ----
youtube = Google::Apis::YoutubeV3::YouTubeService.new
youtube.authorization = authorize

video = Google::Apis::YoutubeV3::Video.new(
  snippet: Google::Apis::YoutubeV3::VideoSnippet.new(
    title: options[:title],
    description: options[:description],
    tags: options[:keywords].split(","),
    category_id: options[:category_id]
  ),
  status: Google::Apis::YoutubeV3::VideoStatus.new(
    privacy_status: options[:privacy_status]
  )
)

begin
  puts "⏳ Uploading..."
  res = youtube.insert_video("snippet,status", video,
    upload_source: options[:file],
    content_type: "video/*"
  )
  puts "✅ Uploaded! Video ID: #{res.id}"
rescue => e
  warn "❌ Upload failed: #{e.message}"
end

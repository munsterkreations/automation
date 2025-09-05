require "google/apis/youtube_v3"
require "signet/oauth_2/client"
require "json"
require "launchy"
require "webrick"

RESPONSE_HTML = <<~HTML
<html>
  <head><title>OAuth 2 Flow Complete</title></head>
  <body>
    ✅ You have successfully completed the OAuth 2 flow.<br>
    You may now close this window.
  </body>
</html>
HTML

CREDENTIALS_FILE = "credentials.json"  # downloaded from Google Cloud Console
TOKEN_FILE = "token.json"              # local storage for your tokens

class CommandLineOAuthHelper
  def initialize(scope)
    credentials = JSON.parse(File.read(CREDENTIALS_FILE))
    @authorization = Signet::OAuth2::Client.new(
      client_id: credentials["installed"]["client_id"],
      client_secret: credentials["installed"]["client_secret"],
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      redirect_uri: credentials["installed"]["redirect_uris"].first,
      scope: scope
    )
  end

  def authorize
    if File.exist?(TOKEN_FILE)
      token_data = JSON.parse(File.read(TOKEN_FILE))
      @authorization.update_token!(token_data)
      if @authorization.expired?
        @authorization.fetch_access_token!
        save_token
      end
    else
      start_local_server
    end

    @authorization
  end

  private

  def start_local_server
    server = WEBrick::HTTPServer.new(
      Port: 8080,
      Logger: WEBrick::Log.new(File::NULL),
      AccessLog: []
    )

    server.mount_proc "/" do |req, res|
      @authorization.code = req.query["code"]
      @authorization.fetch_access_token!
      save_token
      res.body = RESPONSE_HTML
      server.shutdown
    end

    Launchy.open(@authorization.authorization_uri.to_s)
    trap("INT") { server.shutdown }
    server.start
  end

  def save_token
    File.open(TOKEN_FILE, "w", 0600) do |file|
      file.write(JSON.pretty_generate(@authorization.to_h))
    end
  end
end

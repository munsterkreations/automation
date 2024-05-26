# frozen_string_literal: true

require_relative "automation/version"

module Automation
  class Error < StandardError; end
   class automation
    def initialize(client_id, client_secret, redirect_uri, refresh_token)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @refresh_token = refresh_token
      @youtube = Google::Apis::YoutubeV3::YouTubeService.new
      @youtube.authorization = authorize
    end
    def authorize
      client = Google::Apis::ClientOptions.default
      client.client_id = @client_id
      client.client_secret = @client_secret
      client.scope = Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL
      client.authorization_uri = "https://accounts.google.com/o/oauth2/auth"
      client.token_credential_uri = "https://oauth2.googleapis.com/token"
      client.redirect_uri = @redirect_uri
      client.refresh_token = @refresh_token
      client
    end

    def upload_video(title, description, video_path)
      video = Google::Apis::YoutubeV3::Video.new
      video.video.title = title
      video.video.description = description
      video.snippet = Google::Apis::YoutubeV3::VideoSnippet.new
      video.snippet.title = title
      video.snippet.description = description
      video.snippet.tags = ["Ruby", "Google API"]
      video.snippet.category_id = "22"
      video.status = Google::Apis::YoutubeV3::VideoStatus.new
      video.status.privacy_status = "public"
      video.status.embeddable = true
      video.status.license = "creativeCommon"
      response = @youtube.insert_video("snippet,status", video, upload_source: video_path, content_type: "video/*")
      response.id
      end
    
    def create_playlist(title, description, video_id)
      playlist = Google::Apis::YoutubeV3::Playlist.new
      playlist.snippet = Google::Apis::YoutubeV3::PlaylistSnippet.new
      playlist.snippet.title = title
      playlist.snippet.description = description
      playlist.snippet.tags = ["Ruby", "Google API"]
      playlist.snippet.category_id = "22"
      playlist.status = Google::Apis::YoutubeV3::PlaylistStatus.new
      playlist.status.privacy_status = "public"
      playlist.status.embeddable = true
      playlist.status.license = "creativeCommon"
      response = @youtube.insert_playlist("snippet,", playlist_item, upload_source: video_id, content_type: "video/*")
      response.id
    end
    def update_video_metadata(video_id, title, description)
      video = @youtube.list_videos("snippet", id: video_id).items.first
      video.snippet.title = title
      video.snippet.description = description
      @youtube.update_video("snippet,status", video, video_id)
    end
def delete_video(video_id)
  @youtube.delete_video(video_id)
end
  end
end

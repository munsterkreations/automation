require_relative "automation/version"
require "google/apis/youtube_v3"
require "signet/oauth_2/client"

module Automation
  class Error < StandardError; end

  class Client
    def initialize(client_id, client_secret, redirect_uri, refresh_token)
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @refresh_token = refresh_token

      @youtube = Google::Apis::YoutubeV3::YouTubeService.new
      @youtube.authorization = authorize
    end

    def authorize
      Signet::OAuth2::Client.new(
        client_id: @client_id,
        client_secret: @client_secret,
        token_credential_uri: "https://oauth2.googleapis.com/token",
        refresh_token: @refresh_token,
        redirect_uri: @redirect_uri,
        scope: Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL
      )
    end

    def upload_video(title, description, video_path)
      video = Google::Apis::YoutubeV3::Video.new(
        snippet: Google::Apis::YoutubeV3::VideoSnippet.new(
          title: title,
          description: description,
          tags: ["Ruby", "Google API"],
          category_id: "22"
        ),
        status: Google::Apis::YoutubeV3::VideoStatus.new(
          privacy_status: "public",
          embeddable: true,
          license: "creativeCommon"
        )
      )

      response = @youtube.insert_video(
        "snippet,status",
        video,
        upload_source: video_path,
        content_type: "video/*"
      )

      response.id
    end

    def create_playlist(title, description)
      playlist = Google::Apis::YoutubeV3::Playlist.new(
        snippet: Google::Apis::YoutubeV3::PlaylistSnippet.new(
          title: title,
          description: description
        ),
        status: Google::Apis::YoutubeV3::PlaylistStatus.new(
          privacy_status: "public"
        )
      )

      response = @youtube.insert_playlist("snippet,status", playlist)
      response.id
    end

    def add_video_to_playlist(playlist_id, video_id)
      playlist_item = Google::Apis::YoutubeV3::PlaylistItem.new(
        snippet: Google::Apis::YoutubeV3::PlaylistItemSnippet.new(
          playlist_id: playlist_id,
          resource_id: Google::Apis::YoutubeV3::ResourceId.new(
            kind: "youtube#video",
            video_id: video_id
          )
        )
      )

      response = @youtube.insert_playlist_item("snippet", playlist_item)
      response.id
    end

    def update_video_metadata(video_id, title, description)
      video = @youtube.list_videos("snippet,status", id: video_id).items.first
      video.snippet.title = title
      video.snippet.description = description
      @youtube.update_video("snippet,status", video)
    end

    def delete_video(video_id)
      @youtube.delete_video(video_id)
    end
  end
end

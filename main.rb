#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/automation"
require_relative "lib/oauth_util"
require "optparse"
require "json"

# Main entry point for the automation program
class AutomationCLI
  SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL

  def initialize
    @options = parse_options
  end

  def run
    case @options[:command]
    when "upload"
      upload_video
    when "playlist"
      create_playlist
    when "auth"
      authenticate
    else
      show_help
    end
  end

  private

  def parse_options
    options = {
      command: ARGV[0],
      file: nil,
      title: "Untitled Video",
      description: "Uploaded via Automation gem",
      privacy: "public",
      category: "22",
      keywords: []
    }

    OptionParser.new do |opts|
      opts.banner = "Usage: ruby main.rb [command] [options]"
      opts.separator ""
      opts.separator "Commands:"
      opts.separator "  upload      Upload a video to YouTube"
      opts.separator "  playlist    Create a new playlist"
      opts.separator "  auth        Authenticate with YouTube"
      opts.separator ""
      opts.separator "Options:"

      opts.on("-f", "--file FILE", "Video file to upload") { |v| options[:file] = v }
      opts.on("-t", "--title TITLE", "Video title") { |v| options[:title] = v }
      opts.on("-d", "--description DESC", "Video description") { |v| options[:description] = v }
      opts.on("-p", "--privacy STATUS", "Privacy: public|private|unlisted") { |v| options[:privacy] = v }
      opts.on("-c", "--category ID", "Category ID (default: 22)") { |v| options[:category] = v }
      opts.on("-k", "--keywords x,y,z", Array, "Keywords (comma-separated)") { |v| options[:keywords] = v }
      opts.on("-h", "--help", "Show this help message") do
        puts opts
        exit
      end
    end.parse!

    options
  end

  def authenticate
    puts "🔐 Starting OAuth authentication..."
    helper = CommandLineOAuthHelper.new(SCOPE)
    auth = helper.authorize
    puts "✅ Authentication successful!"
    puts "Token saved to token.json"
  rescue => e
    puts "❌ Authentication failed: #{e.message}"
    exit 1
  end

  def upload_video
    unless @options[:file] && File.exist?(@options[:file])
      puts "❌ Error: Must specify a valid video file with --file"
      exit 1
    end

    puts "🔐 Authenticating..."
    helper = CommandLineOAuthHelper.new(SCOPE)
    auth = helper.authorize

    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = auth

    video = Google::Apis::YoutubeV3::Video.new(
      snippet: Google::Apis::YoutubeV3::VideoSnippet.new(
        title: @options[:title],
        description: @options[:description],
        tags: @options[:keywords],
        category_id: @options[:category]
      ),
      status: Google::Apis::YoutubeV3::VideoStatus.new(
        privacy_status: @options[:privacy]
      )
    )

    puts "⏳ Uploading video: #{@options[:title]}..."
    result = youtube.insert_video(
      "snippet,status",
      video,
      upload_source: @options[:file],
      content_type: "video/*"
    )

    puts "✅ Upload successful!"
    puts "Video ID: #{result.id}"
    puts "URL: https://www.youtube.com/watch?v=#{result.id}"
  rescue => e
    puts "❌ Upload failed: #{e.message}"
    exit 1
  end

  def create_playlist
    puts "🔐 Authenticating..."
    helper = CommandLineOAuthHelper.new(SCOPE)
    auth = helper.authorize

    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = auth

    playlist = Google::Apis::YoutubeV3::Playlist.new(
      snippet: Google::Apis::YoutubeV3::PlaylistSnippet.new(
        title: @options[:title],
        description: @options[:description]
      ),
      status: Google::Apis::YoutubeV3::PlaylistStatus.new(
        privacy_status: @options[:privacy]
      )
    )

    puts "⏳ Creating playlist: #{@options[:title]}..."
    result = youtube.insert_playlist("snippet,status", playlist)

    puts "✅ Playlist created!"
    puts "Playlist ID: #{result.id}"
  rescue => e
    puts "❌ Playlist creation failed: #{e.message}"
    exit 1
  end

  def show_help
    puts <<~HELP
      Automation - YouTube Channel Automation Tool

      Usage:
        ruby main.rb [command] [options]

      Commands:
        auth        Authenticate with YouTube (run this first)
        upload      Upload a video to YouTube
        playlist    Create a new playlist

      Examples:
        # Authenticate first
        ruby main.rb auth

        # Upload a video
        ruby main.rb upload --file video.mp4 --title "My Video" --description "Description"

        # Create a playlist
        ruby main.rb playlist --title "My Playlist" --description "Playlist description"

      For more options, use: ruby main.rb [command] --help
    HELP
  end
end

# Run the CLI if this file is executed directly
if __FILE__ == $PROGRAM_NAME
  AutomationCLI.new.run
end

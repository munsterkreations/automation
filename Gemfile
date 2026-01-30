source "https://rubygems.org"

# --- Core Gems ---                  # environment variables
gem "dotenv", "~> 3.2"
gem "rake", "~> 13.0"
gem "rdoc", "~> 6.3"

# --- YouTube Automation / Custom Gem ---
gemspec                           is        # includes your automation gem locally
gem "google-apis-youtube_v3", "~> 0.61.0"
gem "signet", "~> 0.19"
gem "launchy", "~> 2.5"

# --- Jekyll / GitHub Pages ---
gem "github-pages", group: :jekyll_plugins
gem "jekyll", "~> 4.2"                 # optional, overrides GitHub Pages Jekyll if needed
gem "jekyll-github-metadata"

# --- Jekyll plugins ---
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
end

# --- Testing ---
gem "rspec", "~> 3.12"

# --- Platform-specific (Windows) ---
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
  gem "wdm", "~> 0.1.1"
end

# --- JRuby support ---
platforms :jruby do
  gem "http_parser.rb", "~> 0.6.0"
end

# frozen_string_literal: true

require_relative "lib/automation/version"

Gem::Specification.new do |spec|
  spec.name          = "automation"
  spec.version       = Automation::VERSION
  spec.authors       = ["munsterkreations"]
  spec.email         = ["munsterkreations@users.noreply.github.com"]

  spec.summary       = "The automation gem provides a simple interface for interacting with social media APIs like YouTube, TikTok, and Instagram."
  spec.description   = <<~DESC
    The Automation gem is a versatile tool for interacting with social media platforms. 
    It provides easy-to-use classes for uploading videos to YouTube, managing playlists, 
    and scraping basic data from popular platforms. Built-in error handling and configuration 
    options simplify automation workflows.
  DESC

  spec.homepage      = "https://github.com/munsterkreations/automation"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Metadata
  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "https://github.com/munsterkreations/automation/blob/main/CHANGELOG.md"

  # Include only relevant files (exclude tests, hidden files, tmp, etc.)
  spec.files = Dir.glob("lib/**/*") + ["README.md", "LICENSE.txt"]

  # Exclude test/ spec/ features/ tmp/ directories and hidden files
  spec.files.reject! do |f|
    f =~ %r{^(test|spec|features|tmp|\.|exe/)} || File.directory?(f)
  end

  # Automatically include any executables in exe/
  spec.bindir      = "exe"
  exe_files = Dir.glob("exe/*").select { |f| File.file?(f) }
  spec.executables = exe_files.map { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "google-apis-youtube_v3", "~> 0.61.0"
  spec.add_dependency "signet", "~> 0.19"
  spec.add_dependency "launchy", "~> 2.5"
  spec.add_dependency "dotenv", "~> 3.2"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "rdoc", "~> 6.3"
  spec.add_dependency "rspec", "~> 3.12"

  # Optional: GitHub Pages / Jekyll support
  spec.add_dependency "github-pages"
  spec.add_dependency "jekyll", "~> 4.2"
  spec.add_dependency "jekyll-github-metadata"
end

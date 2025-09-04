# frozen_string_literal: true

require_relative "lib/automation/version"

Gem::Specification.new do |spec|
  spec.name = "automation"
  spec.version =  Automation::VERSION:: 0.1.0
  spec.authors = ["munsterkreations"]
  spec.email = ["munsterkreations@users.noreply.github.com"]

  spec.summary = "The youtube_content_creator provides a simple interface for scraping data from popular social media platforms like TikTok and Instagram."
  
  spec.description = "The DataScraper is a versatile tool for scraping data from popular social media platforms like TikTok and Instagram. 
   It provides easy-to-use classes for extracting user information, such as follower counts and following counts. With built-in error handling and customizable configuration options,
   the DataScraper simplifies the process of collecting data from these platforms. 
   Start scraping user data effortlessly with just a few lines of code"

  spec.homepage = "https://github.com/munsterkreations/automation.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the Rubythat have been added into git.
  spec.files = `git ls-files -z`.split("\x0").reject { |f|
      (File.expand_path(f) == __FILE__) ||
        f.match(%r{^(bin/ test/ spec/ features)/}[ .git .circleci appveyor Gemfile])}
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
   spec.add_dependency "google-api-client", "~> 0.41"
    spec.add_dependency "rdoc", "~> 6.3"
   spec.add_dependency "nokogiri" "~> 1.8"
   spec.add_dependency "jekyll", "~> 4.3.3"
   spec.add_dependency "dotenv"
   spec.add_dependency "github-pages"
   spec.add_dependency "jekyll-github-metadata"
   spec.add_dependency "rake", "~> 13.0"
   spec.add_dependency "automation", "~> 0.1.0"
   spec.add_dependency "rspec/minitest/test-unit/test", "~> "
   

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Development-time benchmarking and logging aids
  gem "require_bench", require: false
  gem "debug_logging", require: false
  gem "gem_bench", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Linting
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  #gem "rubocop-rails-omakase", require: false
  gem "betterlint"
  gem "rubocop-lts", "~> 24.0", ">= 24.0.2"
  gem "standard", ">= 1.50"
  gem "standard-rails"

  # Testing
  gem "kettle-soup-cover", "~> 1.0", ">= 1.0.10", require: false
  gem "rspec-rails", "~> 8.0"
  gem "rspec-block_is_expected", "~> 1.0", ">= 1.0.6"
  gem "rspec-stubbed_env", "~> 1.0", ">= 1.0.4"
  gem "silent_stream", "~> 1.0", ">= 1.0.11"
  gem "timecop", "~> 0.9", ">= 0.9.10"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # File watching to auto-run tasks in development
  gem "guard", require: false
  gem "guard-rake", require: false
  gem "guard-rails", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "rspec_junit_formatter", "~> 0.6"
end

gem "dockerfile-rails", ">= 1.7", group: :development

gem "litestream", "~> 0.14.0"

gem "redis", "~> 5.4"

gem "aws-sdk-s3", "~> 1.196", require: false

gem "flag_shih_tzu", "~> 0.3.23"
gem "sanitize_email", "~> 2.0", ">= 2.0.10"


# Authentication via OmniAuth Identity (email/password only)
gem "omniauth", "~> 2.1"
# CSRF protection for OmniAuth 2.x
gem "omniauth-rails_csrf_protection", "~> 1.0"
# Provider strategies
gem "omniauth-identity", "~> 3.0"
# Base OAuth2 strategy (used for custom Codeberg strategy)
gem "omniauth-oauth2", "~> 1.8"
# Password hashing for Identity
gem "bcrypt", "~> 3.1"

# Enumerations
gem "enumerate_it", "~> 4.1"

# Tailwind CSS integration
gem "tailwindcss-rails", "~> 4.3"

gem "lucide-rails"

gem "sentry-ruby"
gem "sentry-rails"

# Experimental additions
# Security and safety
gem "active_security"
# ActiveRecord / ActiveSupport extensions and utilities
# gem "activerecord-transactionable"
# TODO: Can't use these until fixed:
#       ActiveSupport::Concern::MultipleIncludedBlocks: Cannot define multiple 'included' blocks for a Concern (ActiveSupport::Concern::MultipleIncludedBlocks)
#       Reproduce with:
#          RAILS_ENV=production bin/rails assets:precompile
# gem "activesupport-broadcast_logger", require: false
# gem "activesupport-logger", require: false
# gem "activesupport-tagged_logging", require: false
# Error and tagging helpers
# gem "destination_errors"
# Migrations and data management
# gem "seed_migration"
# Model utilities
# gem "shiftable"
# gem "simple_column-scopes" # TODO: Fix circular require warning
# gem "status_tag"

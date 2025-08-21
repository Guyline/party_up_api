source "https://rubygems.org"

ruby "3.4.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0"

# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.6"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.13"

# Use Redis adapter to run Action Cable in productionn
# gem "redis", ">= 4.0.1"
gem "redis", "~> 5.4"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem "devise", "~> 4.9"
gem "doorkeeper", "~> 5.8"
gem "doorkeeper-jwt", "~> 0.4"
# gem 'omniauth', '~> 2.1'
# gem 'omniauth-google-oauth2', '~> 1.2'
gem "googleauth", "~> 1.14"

gem "countries", "~> 8.0"
gem "discard", "~> 1.4"
gem "kaminari", "~> 1.2"
gem "money-rails", "~> 1.15"
gem "nokogiri", "~> 1.18"
gem "rest-client", "~> 2.1"

gem "sidekiq", "~> 8.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails", "~> 3.1"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "rdoc", "~> 6.14"
  gem "standard", "~> 1.50", require: false
  gem "standard-rails", "~> 1.4", require: false
end

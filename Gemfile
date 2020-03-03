# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'react-rails'
gem 'webpacker', '~> 4.0'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'hashugar'
gem 'lastfm-client', github: 'pch/lastfm-client'
gem 'musicbrainz'

group :development, :test do
  gem 'pry', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-nav', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 0.79.0', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

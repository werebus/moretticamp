# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'aws-sdk-rails',          '~> 2.1'
gem 'bootsnap'
gem 'cssbundling-rails'
gem 'devise',                 '~> 4.8.0'
gem 'devise_invitable'
gem 'exception_notification'
gem 'figaro'
gem 'foundation_rails_helper',
  github: 'werebus/foundation_rails_helper',
  branch: 'rails-7'
gem 'haml-rails',             '~> 2.0'
gem 'icalendar'
gem 'io-wait'
gem 'jbuilder',               '~> 2.0'
gem 'jsbundling-rails'
gem 'kramdown'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'propshaft'
gem 'puma'
gem 'rails',                  '~> 7.0.0'
gem 'twilio-ruby',            '~> 5.8'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'capistrano',           '~> 3.11', require: false
  gem 'capistrano-bundler',              require: false
  gem 'capistrano-passenger',            require: false
  gem 'capistrano-pending',              require: false
  gem 'capistrano-rails',                require: false
  gem 'ed25519'
  gem 'listen'
  gem 'rubocop',                         require: false
  gem 'rubocop-rails',                   require: false
  gem 'rubocop-rspec',                   require: false
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pdf-inspector',     require: 'pdf/inspector'
  gem 'rspec-rails'
  gem 'webdrivers'
  gem 'simplecov',         require: false
  gem 'timecop'
end

group :production do
  gem 'resque'
end

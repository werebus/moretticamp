# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'aws-sdk-rails',          '~> 2.1'
gem 'bootsnap'
gem 'devise',                 '~> 4.8.0'
gem 'devise_invitable'
gem 'exception_notification'
gem 'figaro'
gem 'foundation_rails_helper',
  github: 'sgruhier/foundation_rails_helper'
gem 'haml-rails',             '~> 2.0'
gem 'icalendar'
gem 'jbuilder',               '~> 2.0'
gem 'kramdown'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails',                  '~> 6.1.0'
gem 'twilio-ruby',            '~> 5.8'
gem 'webpacker',              '~> 4.0'

group :development do
  gem 'capistrano',           '~> 3.11', require: false
  gem 'capistrano-bundler',              require: false
  gem 'capistrano-passenger',            require: false
  gem 'capistrano-pending',              require: false
  gem 'capistrano-rails',                require: false
  gem 'listen'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop',                         require: false
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

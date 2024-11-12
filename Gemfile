# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'aws-sdk-rails',          '~> 3.13'
gem 'bootsnap'
gem 'bootstrap_form',         '~> 5.4'
gem 'cssbundling-rails'
gem 'devise',                 '~> 4.9.4'
gem 'devise_invitable'
gem 'exception_notification'
gem 'haml-rails',             '~> 2.0'
gem 'icalendar'
gem 'jbuilder',               '~> 2.13'
gem 'jsbundling-rails'
gem 'kramdown'
gem 'matrix'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'propshaft'
gem 'puma'
gem 'rack-attack'
gem 'rails',                  '~> 7.1.3'
gem 'twilio-ruby',            '~> 7.3'

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
  gem 'selenium-webdriver'
  gem 'simplecov',         require: false
  gem 'timecop'
end

group :production do
  gem 'resque'
end

# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'aws-actionmailer-ses'
gem 'aws-sdk-rails', '~> 5.0'
gem 'bootsnap'
gem 'bootstrap_form', '~> 5.4'
gem 'cssbundling-rails'
gem 'devise', '~> 4.9.4'
gem 'devise_invitable'
gem 'exception_notification'
gem 'haml-rails'
gem 'icalendar'
gem 'jbuilder'
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
gem 'rack-attack'
gem 'rails', '~> 7.2.2'
# TODO: Remove when Rails 7.2.3 is released
# see rails/rails#53850
gem 'securerandom', '~> 0.3.2'
gem 'turbo-rails'
gem 'twilio-ruby', '~> 7.3'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'brakeman', require: false
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519'
  gem 'haml_lint', require: false
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :production do
  gem 'solid_queue'
end

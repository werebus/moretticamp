# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'aws-sdk-rails',          '~> 2.1'
gem 'bootsnap'
gem 'devise',                 '~> 4.6.0'
gem 'devise_invitable',       '~> 1.6.0'
gem 'exception_notification'
gem 'figaro'
gem 'foundation_rails_helper'
gem 'haml-rails',             '~> 1.0'
gem 'icalendar'
gem 'jbuilder',               '~> 2.0'
gem 'kramdown'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails',                  '~> 5.2.0'
gem 'twilio-ruby',            '~> 5.8'
gem 'webpacker',              '~> 4.x'

group :development do
  gem 'capistrano',         '~> 3.4.0', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-pending',             require: false
  gem 'capistrano-rails',   '~> 1.1.1', require: false
  gem 'listen'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop',                        require: false
  gem 'spring'
end

group :test do
  gem 'capybara',                '~> 3.10'
  gem 'faker'
  gem 'fuubar'
  gem 'pdf-inspector',                      require: 'pdf/inspector'
  gem 'rails-controller-testing'
  gem 'rspec-rails',             '~> 3.7.2'
  gem 'selenium-webdriver'
  gem 'simplecov',                          require: false
  gem 'timecop'
end

group :development, :test do
  gem 'factory_bot_rails'
end

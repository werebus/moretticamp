source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.8'

# Use postgres as the database for Active Record
gem 'pg'

# Figaro manages app secrets in ENV
gem 'figaro'

# Use HAML for views
gem 'haml-rails', '~> 0.9'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'
gem 'foundation-rails'
gem 'foundation_rails_helper'
gem 'rails-assets-foundation-datepicker', source: 'https://rails-assets.org'
gem "font-awesome-sass"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Twilio for voice access
gem 'twilio-ruby'

# Mail with SES
gem 'aws-ses'

# Devise for auth
gem 'devise', '>= 2.0.0'
gem 'devise_invitable', '~> 1.6.0'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

# Calendar View
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# Clipboard
gem 'zeroclipboard-rails'

# Prawn - printable calendar
gem 'prawn'
gem 'prawn-table'

gem 'kramdown'

gem 'exception_notification'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  gem 'spring'
  gem 'pry'
  gem 'pry-byebug'
  gem 'capistrano', '~> 3.4.0', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-rails', '~> 1.1.1', require: false
  gem 'capistrano-pending', require: false
  gem 'rubocop', require: false
end

group :test do
  gem 'faker'
end

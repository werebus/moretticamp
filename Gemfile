# frozen_string_literal: true

source 'https://rubygems.org'

gem 'aws-ses'
gem 'bootsnap'
gem 'coffee-rails',           '~> 4.2.1'  #A
gem 'devise',                 '~> 4.4.3'
gem 'devise_invitable',       '~> 1.6.0'
gem 'exception_notification'
gem 'figaro'
gem 'font-awesome-sass'                   #A
gem 'foundation-rails',       '~> 6.4'    #A
gem 'foundation_rails_helper'             #A
gem 'fullcalendar-rails'                  #A
gem 'haml-rails',             '~> 1.0'
gem 'jbuilder',               '~> 2.0'
gem 'jquery-rails'                        #A
gem 'kramdown'
gem 'momentjs-rails'                      #A
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'pg'
gem 'prawn'
gem 'prawn-table'
gem 'rails',                  '~> 5.2.0'
gem 'sass-rails',             '~> 5.0.0'  #A
gem 'twilio-ruby',            '~> 5.8'
gem 'uglifier',               '>= 1.3.0'  #A

source 'https://rails-assets.org' do
  gem 'rails-assets-clipboard'            #A
  gem 'rails-assets-foundation-datepicker'#A
end

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
  gem 'faker'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

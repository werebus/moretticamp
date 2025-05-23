# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

Rails.root.join('spec/support').glob('**/*.rb').sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, :js, type: :system) do
    driven_by :selenium, using: :headless_firefox
  end

  # TODO: heartcombo/devise#5728
  config.before(:suite) do
    Rails.application.reload_routes_unless_loaded
  end
end

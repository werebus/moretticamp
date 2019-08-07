# frozen_string_literal: true

require File.expand_path('config/application', __dir__)
Rails.application.load_tasks

require 'resque/tasks'
task 'resque:setup' => :environment

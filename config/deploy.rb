# frozen_string_literal: true

lock '~> 3.4.0'

set :application, 'moretticamp'
set :repo_url, 'https://github.com/werebus/moretticamp.git'

set :deploy_to, '/srv/moretticamp'

set :log_level, :info

set :pty, true

set :linked_files, %w[config/database.yml config/application.yml]

set :linked_dirs, %w[log
                     tmp/pids
                     tmp/cache
                     tmp/sockets
                     vendor/bundle
                     public/system]

set :assets_prefix, 'packs'
set :bundle_binstubs, nil

set :passenger_restart_with_touch, true

after 'deploy:published', 'resque:restart'

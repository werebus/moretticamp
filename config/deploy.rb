# frozen_string_literal: true

lock '~> 3.11'

set :application, 'moretticamp'
set :repo_url, 'https://github.com/werebus/moretticamp.git'

set :deploy_to, '/srv/moretticamp'

set :log_level, :info

append :linked_files, 'config/database.yml', 'config/application.yml'
append :linked_dirs, 'log',
                     'tmp/pids',
                     'tmp/cache',
                     'tmp/sockets',
                     'vendor/bundle',
                     'public/system'

set :assets_prefix, 'packs'
set :passenger_restart_with_touch, true

after 'deploy:published', 'resque:restart'

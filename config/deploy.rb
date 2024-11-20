# frozen_string_literal: true

lock '~> 3.11'

set :application, 'moretticamp'
set :repo_url, 'https://github.com/werebus/moretticamp.git'
set :branch, 'main'

set :deploy_to, '/srv/moretticamp'

set :log_level, :info

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs,
       'log',
       'node_modules',
       'tmp/pids',
       'tmp/cache',
       'tmp/sockets',
       'vendor/bundle',
       'public/system'

set :passenger_restart_with_touch, true

after 'deploy:published', 'resque:restart'

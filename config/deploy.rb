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
set :solid_queue_systemd_unit_name, 'solid_queue.service'

after 'deploy:published', 'resque:restart'
after 'deploy:starting', 'solid_queue:quiet'
after 'deploy:updated', 'solid_queue:stop'
after 'deploy:published', 'solid_queue:start'
after 'deploy:failed', 'solid_queue:restart'

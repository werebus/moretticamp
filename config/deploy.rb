# frozen_string_literal: true

# config valid only for Capistrano 3.4.1
lock '3.4.1'

set :application, 'moretticamp'
set :repo_url, 'https://github.com/werebus/moretticamp.git'

set :deploy_to, '/srv/moretticamp'

set :log_level, :info

set :pty, true

set :linked_files, %w(config/database.yml config/application.yml)

set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system)

set :bundle_binstubs, nil

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

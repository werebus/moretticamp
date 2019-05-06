# frozen_string_literal: true

server 'staging.moretti.camp', roles: %w[web app db], user: 'matt'
set :ssh_options, forward_agent: true
set :rails_env, 'production'

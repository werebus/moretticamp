set :stage, :production
server 'moretti.camp', roles: %w{web app}

set :ssh_options, {
  forward_agent: true
}

#set :stage, :production

server 'moretti.camp', roles: %w{web app}, user: 'matt'

set :ssh_options, {
  forward_agent: true
}

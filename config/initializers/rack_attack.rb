# frozen_string_literal: true

Rack::Attack.throttle 'req/ip', limit: 1000, period: 5.minutes do |req|
  req.ip unless req.path.start_with?('/assets')
end

Rack::Attack.throttle 'logins/ip', limit: 5, period: 20.seconds do |req|
  req.ip if req.path == '/users/sign_in' && req.post?
end

Rack::Attack.throttle 'logins/email', limit: 5, period: 1.minute do |req|
  if req.path == '/users/sign_in' && req.post?
    req.params['email'].to_s.downcase.remove(/\s+/).presence
  end
end

Rack::Attack.blocklist 'fail2ban pentesters' do |req|
  Rack::Attack::Fail2Ban.filter "pentesters-#{req.ip}", maxretry: 2, findtime: 10.minutes, bantime: 5.minutes do
    CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
    req.path.include?('/etc/passwd') ||
    req.path.include?('/wp-admin') ||
    req.path.include?('/phpmyadmin') ||
    req.path.include?('/.env') ||
    req.path.include?('/cgi-bin')
  end
end

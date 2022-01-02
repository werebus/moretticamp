# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.configure do
  config.content_security_policy do |policy|
   policy.default_src :self
   policy.font_src    :self, :data
   policy.img_src     :self, :data
   policy.object_src  :none
   policy.script_src  :self
   policy.style_src   :self
   policy.connect_src :self

   # Specify URI for violation reports
   # policy.report_uri "/csp-violation-report-endpoint"

   break unless Rails.env.development?

   policy.connect_src :self, 'http://localhost:3035', 'ws://localhost:3035'
 end

 # Generate session nonces for permitted importmap and inline scripts
 config.content_security_policy_nonce_generator =
   ->(request) { request.session.id.to_s }
 config.content_security_policy_nonce_directives = %w[script-src]

 # Report CSP violations to a specified URI. See:
 # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
 # config.content_security_policy_report_only = true
end

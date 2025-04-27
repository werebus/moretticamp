# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger]
  config.dsn = "https://c19a3cc721b0690f4e3cd46684281381@o4509191950303232.ingest.us.sentry.io/4509191952400384"
  config.traces_sample_rate = 1.0
  config.enabled_environments = ['production']
end

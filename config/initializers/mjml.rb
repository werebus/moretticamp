# frozen_string_literal: true

# MJML configuration
Mjml.setup do |config|
  config.template_language = :haml
  config.raise_render_exception = true
  config.use_mrml = true
  config.cache_mjml = false
  config.fonts = nil
end

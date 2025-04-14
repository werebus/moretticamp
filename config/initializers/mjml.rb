# frozen_string_literal: true

# MJML configuration
Mjml.setup do |config|
  config.template_language = :haml
  config.raise_render_exception = true
  config.beautify = true
  config.minify = false
  # Possible values: 'strict', 'soft'
  config.validation_level = 'strict'
  config.use_mrml = false
  config.cache_mjml = false
  config.fonts = nil
end

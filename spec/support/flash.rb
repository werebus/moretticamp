# frozen_string_literal: true

Capybara.add_selector(:flash_type) do
  css { |type| ".flash.#{type}" }
end

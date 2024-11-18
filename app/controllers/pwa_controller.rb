# frozen_string_literal: true

require 'rails/application_controller'

class PwaController < Rails::ApplicationController
  skip_forgery_protection

  def manifest
    render template: 'pwa/manifest', layout: false
  end
end

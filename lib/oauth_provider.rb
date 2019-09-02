# frozen_string_literal: true

require 'forwardable'

class OauthProvider
  @@instances ||= []

  attr_reader :label, :name, :icon, :app_id, :app_secret

  class << self
    def [](label)
      all.find { |p| p.label == label.to_sym }
    end

    def all
      @@instances
    end

    def labels
      all.map(&:label)
    end
  end

  def initialize(label, name, icon, app_id, app_secret)
    @label, @name, @icon, @app_id, @app_secret =
      label, name, icon, app_id, app_secret

    @@instances << self
  end
end

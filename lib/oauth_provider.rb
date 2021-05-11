# frozen_string_literal: true

class OauthProvider
  @instances ||= []

  attr_reader :label, :name, :icon, :app_id, :app_secret

  class << self
    attr_accessor :instances
    alias all instances

    def [](label)
      return if label.nil?

      all.find { |p| p.label == label.to_sym }
    end

    def labels
      all.map(&:label)
    end
  end

  def initialize(label, name, icon, app_id, app_secret)
    @label = label
    @name = name
    @icon = icon
    @app_id = app_id
    @app_secret = app_secret

    self.class.instances << self
  end
end

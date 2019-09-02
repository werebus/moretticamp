# frozen_string_literal: true

require 'forwardable'

class OauthProvider
  @instances ||= []

  attr_reader :label, :name, :icon, :app_id, :app_secret

  class << self
    attr_accessor :instances

    def [](label)
      all.find { |p| p.label == label.to_sym }
    end

    def all
      @instances
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

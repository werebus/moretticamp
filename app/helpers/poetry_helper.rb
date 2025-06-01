# frozen_string_literal: true

module PoetryHelper
  def poem
    Rails.application.config.poetry[:poems].sample
  end
end

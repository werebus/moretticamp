# frozen_string_literal: true

module SeasonYear
  extend self

  def year
    current = Date.today.year
    if Date.today.after?(Date.new(current, 11, 20))
      current += 1
    end
    current
  end
end

RSpec.configure do |config|
  config.include SeasonYear
end

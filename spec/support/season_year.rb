# frozen_string_literal: true

module SeasonYear
  def year
    current = Date.today.year
    current + (Date.today.after?(Date.new(current, 11, 20)) ? 0 : 1)
  end
end

RSpec.configure do |config|
  config.include SeasonYear
end

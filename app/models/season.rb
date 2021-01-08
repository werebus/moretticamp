# frozen_string_literal: true

class Season < ApplicationRecord
  include DateRange
  validates_with SeasonValidator

  def months
    firsts = date_range.select { |date| date.day == 1 }
    firsts.unshift start_date.beginning_of_month
    firsts.uniq
  end
end

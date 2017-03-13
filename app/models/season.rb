class SeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? || record.end_date.blank? || (record.end_date - record.start_date) < 0

    overlaps = Season.where('start_date < ? AND end_date > ?',
                            record.end_date,
                            record.start_date).reject { |s| s == record }

    record.errors[:base] << 'Season overlaps with another season' if overlaps.any?
  end
end

class Season < ApplicationRecord
  include DateRange
  validates_with SeasonValidator

  def months
    firsts = date_range.select{ |date| date.day == 1 }
    firsts.unshift start_date.beginning_of_month
    firsts.uniq
  end
end

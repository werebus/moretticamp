# frozen_string_literal: true

class SeasonValidator < ActiveModel::Validator
  def validate(record)
    overlaps = Season.where('start_date < ? AND end_date > ? AND id != ?',
                            record.end_date,
                            record.start_date,
                            record.id.to_i).first

    return unless overlaps.present?

    record.errors.add(:base, 'Season overlaps with another season')
  end
end

class Season < ApplicationRecord
  include DateRange
  validates_with SeasonValidator

  def months
    firsts = date_range.select { |date| date.day == 1 }
    firsts.unshift start_date.beginning_of_month
    firsts.uniq
  end
end

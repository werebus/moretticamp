# frozen_string_literal: true

class Season < ApplicationRecord
  include DateRange
  validates :available, presence: true
  validate :no_overlaps

  def self.current_or_next
    return if (season = super).blank?

    season.available? ? season : nil
  end

  def available?
    available <= Time.zone.now
  end

  def months
    firsts = date_range.select { |date| date.day == 1 }
    firsts.unshift start_date.beginning_of_month
    firsts.uniq
  end

  private

  def no_overlaps
    overlaps = Season.find_by('start_date < ? AND end_date > ? AND id != ?', end_date, start_date, id.to_i)
    return if overlaps.blank?

    errors.add(:base, 'Season overlaps with another season')
  end
end

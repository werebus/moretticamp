# frozen_string_literal: true

class SeasonValidator < ActiveModel::Validator
  def validate(record)
    overlaps = Season.find_by('start_date < ? AND end_date > ? AND id != ?',
                              record.end_date, record.start_date, record.id.to_i)
    return if overlaps.blank?

    record.errors.add(:base, 'Season overlaps with another season')
  end
end

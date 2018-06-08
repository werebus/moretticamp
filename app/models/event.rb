# frozen_string_literal: true

class EventSeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? || record.end_date.blank?

    season = Season.current_or_next
    unless season.present?
      record.errors[:base] <<
        'Your event cannot be created because there is no season defined yet.'
      return
    end
    return if season.date_range.include?(record.date_range)
    record.errors[:base] <<
      'Event must occur durring the current season' \
      " (#{season.date_range_words})."
  end
end

class Event < ApplicationRecord
  include DateRange
  validates_with EventSeasonValidator

  belongs_to :user, optional: true

  def display_title
    title.present? ? title : user.try(:first_name)
  end
end

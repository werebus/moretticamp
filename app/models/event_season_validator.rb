# frozen_string_literal: true

class EventSeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? || record.end_date.blank?

    errors = []
    season = Season.current_or_next
    errors << no_season(season)
    errors << not_in_season(record, season) if season.present?
    record.errors.add(:base, errors.compact) if errors.any?(&:present?)
  end

  def no_season(season)
    return if season.present?

    'Your event cannot be created because there is no season defined yet.'
  end

  def not_in_season(record, season)
    return if season.date_range.include?(record.date_range)

    "Event must occur durring the current season (#{season.date_range_words})."
  end
end

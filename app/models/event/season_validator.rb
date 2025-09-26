# frozen_string_literal: true

class Event
  class SeasonValidator < ActiveModel::Validator
    def validate(event)
      # Skip if it's not a real date range
      return if [0, Float::INFINITY].include? event.date_range.count

      no_season(event) and return if season.blank?

      not_in_season(event) unless in_season?(event)
    end

    private

    def no_season(event)
      event.errors.add :base, 'There is no current available season'
    end

    def not_in_season(event)
      event.errors.add :base, <<~ERROR
        Must occur durring the current season (#{season.date_range_words})
      ERROR
    end

    def season
      Season.current_or_next
    end

    def in_season?(event)
      season.date_range.include? event.date_range
    end
  end
end

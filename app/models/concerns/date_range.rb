# frozen_string_literal: true

module DateRange
  extend ActiveSupport::Concern

  included do
    validates :start_date, :end_date, presence: true
    validates :end_date, comparison: { greater_than_or_equal_to: :start_date,
                                       message: 'must be on or after %<count>s' }
  end

  module ClassMethods
    def next_after(date)
      where(start_date: (date..)).order(:start_date).first
    end

    def next
      next_after(Time.zone.today)
    end

    def between(start_date, end_date)
      where('start_date <= ? AND end_date >= ?', end_date, start_date)
    end

    def current
      between(Time.zone.today, Time.zone.today).first
    end

    def current_or_next
      current || send(:next)
    end
  end

  def date_range
    (start_date..end_date)
  end

  def date_range_words
    "#{start_date.to_fs(:short_ordinal)} - #{end_date.to_fs(:short_ordinal)}"
  end

  def date_range_readable
    if start_date == end_date
      "on #{start_date.to_fs(:long_ordinal)}"
    else
      "from #{start_date.to_fs(:long_ordinal)}, until #{end_date.to_fs(:long_ordinal)}"
    end
  end
end

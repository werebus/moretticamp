module DateRange
  extend ActiveSupport::Concern

  included do
    validates_presence_of :start_date, :end_date
    validates :end_date, positive_length: true
  end

  module ClassMethods
    def next_after(date, exclude = [0])
      where("start_date >= ? AND id NOT IN (?)", date, exclude).order(:start_date).first
    end

    def next
      next_after(Date.today)
    end

    def between(start_date, end_date)
      where("start_date <= ? AND end_date >= ?", end_date, start_date)
    end

    def current
      between(Date.today, Date.today).first
    end

    def current_or_next
      current || send(:next)
    end
  end

  def date_range
    (start_date..end_date)
  end

  def date_range_words
    "#{short_date_words(start_date)} - #{short_date_words(end_date)}"
  end

  def date_range_readable
    if start_date == end_date
      "on #{long_date_words(start_date)}"
    else
      "from #{long_date_words(start_date)}, until #{long_date_words(end_date)}"
    end
  end
  
  private

  def short_date_words(date)
    date.strftime('%b ') + date.day.ordinalize
  end

  def long_date_words(date)
    date.strftime('%A, %B ') + date.day.ordinalize
  end
end

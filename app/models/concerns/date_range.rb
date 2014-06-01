module DateRange
  extend ActiveSupport::Concern

  included do
    validates_presence_of :start_date, :end_date
    validates :end_date, positive_length: true
  end

  def date_range
    (start_date..end_date)
  end

  def date_range_words
    start_date.strftime("%b ") + start_date.day.ordinalize + " - " +
      end_date.strftime("%b ") + end_date.day.ordinalize
  end

  def date_range_readable
    if start_date == end_date
      "on " + start_date.strftime("%A, %B ") + start_date.day.ordinalize
    else
      "from " + start_date.strftime("%A, %B ") + start_date.day.ordinalize +
      ", until " + end_date.strftime("%A, %B ") + end_date.day.ordinalize
    end
  end
end

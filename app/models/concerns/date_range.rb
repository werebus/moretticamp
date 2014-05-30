module DateRange
  extend ActiveSupport::Concern

  def date_range
    (start_date..end_date)
  end

  def date_range_words
    start_date.strftime("%b ") + start_date.day.ordinalize + " - " +
      end_date.strftime("%b ") + end_date.day.ordinalize
  end
end

class Season < ActiveRecord::Base
  class << self
    def current_or_next
      current || self.next
    end

    def current
      where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    end

    def next
      where("start_date >= ?", Date.today).order(:start_date).first
    end
  end

  def date_range
    (start_date..end_date)
  end
end

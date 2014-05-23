class Event < ActiveRecord::Base
  belongs_to :user

  def self.between(start_date, end_date)
    where("start_date <= ? AND end_date >= ?", end_date, start_date)
  end
end

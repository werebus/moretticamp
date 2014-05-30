class SeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? or record.end_date.blank?

    overlaps = Season.where("start_date IN (:range) OR end_date IN (:range)",
                            range: record.date_range).reject{|s| s==record}

    if overlaps.any?
      record.errors[:base] << "Season overlaps with another season"
    end
  end
end

class Season < ActiveRecord::Base
  include DateRange

  validates_presence_of :start_date, :end_date
  validates_with SeasonValidator

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
end

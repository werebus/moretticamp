class SeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? or record.end_date.blank? or (record.end_date - record.start_date) < 0

    overlaps = Season.where("start_date < ? AND end_date > ?", record.end_date, record.start_date).reject{|s| s==record}

    if overlaps.any?
      record.errors[:base] << "Season overlaps with another season"
    end
  end
end

class Season < ActiveRecord::Base
  include DateRange
  validates_with SeasonValidator
end

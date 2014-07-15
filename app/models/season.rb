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
  validates_with SeasonValidator
end

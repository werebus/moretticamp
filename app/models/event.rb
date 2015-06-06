class EventSeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? || record.end_date.blank?
    season = Season.current_or_next
    if season.nil?
      record.errors[:base] << 'Your event cannot be created because there is no season defined yet.'
      return
    end
    unless season.date_range.include?(record.date_range)
      record.errors[:base] << "Event must occur durring the current season (#{season.date_range_words})."
    end
  end
end

class Event < ActiveRecord::Base
  include DateRange
  validates_with EventSeasonValidator

  belongs_to :user

  def display_title
    (title.present? ? title : user.try(:first_name) || '')
  end
end

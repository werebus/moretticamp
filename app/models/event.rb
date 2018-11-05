# frozen_string_literal: true

class EventSeasonValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_date.blank? || record.end_date.blank?
    errors = []
    season = Season.current_or_next
    errors << no_season(season)
    errors << not_in_season(record, season)
    record.errors[:base] << errors.compact
  end

  def no_season(season)
    return if season.present?
    'Your event cannot be created because there is no season defined yet.'
  end

  def not_in_season(record, season)
    return if season.date_range.include?(record.date_range)
    "Event must occur durring the current season (#{season.date_range_words})."
  end
end

class Event < ApplicationRecord
  include DateRange
  validates_with EventSeasonValidator

  belongs_to :user, optional: true

  def self.ical(events = all)
    Icalendar::Calendar.new.tap do |cal|
      cal.prodid = '-//wereb.us//moretti.camp//EN'

      events.each do |event|
        cal.add_event event.ical
      end
    end
  end

  def display_title
    title.present? ? title : user.try(:first_name)
  end

  def full_title
    "#{display_title} (#{date_range_words})"
  end

  def ical
    Icalendar::Event.new.tap do |e|
      e.uid = "#{id}@moretti.camp"
      e.status = 'CONFIRMED'
      e.dtstart = Icalendar::Values::Date.new(start_date)
      e.dtend = Icalendar::Values::Date.new(end_date + 1.day)
      e.summary = display_title
      e.description = description
      e.dtstamp = created_at.utc.strftime('%Y%m%dT%H%M%SZ')
      e.last_modified = updated_at.utc.strftime('%Y%m%dT%H%M%SZ')
    end
  end
end

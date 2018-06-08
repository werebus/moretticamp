# frozen_string_literal: true

events = [{ name: 'Camp Opens', date: @current_season.try(:start_date) },
          { name: 'Camp Closes', date: @current_season.try(:end_date) }]

json.array! events do |event|
  json.title event[:name]
  json.start event[:date].try(:iso8601)
  json.allDay true
  json.recurring false
end

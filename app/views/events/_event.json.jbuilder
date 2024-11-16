# frozen_string_literal: true

json.extract! event, :id, :description, :created_at, :updated_at
json.title event.display_title
json.start event.start_date.iso8601
json.end((event.end_date + 1.day).iso8601)
json.allDay true
json.recurring false
json.url event_url(event)
json.color('var(--bs-primary)')
json.classNames 'has-tip' if event.description.present?

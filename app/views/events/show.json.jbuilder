json.extract! @event, :id, :created_at, :updated_at
json.title @event.display_title
json.description @event.description
json.start time_for_json(@event.start_date)
json.end time_for_json(@event.end_date)
json.allDay true
json.recurring false
json.url event_url(@event)

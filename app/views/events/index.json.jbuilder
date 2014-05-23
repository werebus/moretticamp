json.array!(@events) do |event|
  json.extract! event, :id
  json.title event.user.first_name
  json.extract! event, :description
  json.start time_for_json(event.start_date)
  json.end time_for_json(event.end_date)
  json.allDay true
  json.recurring false
  json.url event_url(event)
end

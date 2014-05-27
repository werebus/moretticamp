if @current_season
  json.array!( [@current_season.start_date, @current_season.end_date] ) do |date|
    json.title "Camp Opens" if @current_season.try(:start_date) == date
    json.title "Camp Closes" if @current_season.try(:end_date) == date
    json.start time_for_json(date)
    json.end time_for_json(date)
    json.allDay true
    json.recurring false
  end
else
  json.array!
end

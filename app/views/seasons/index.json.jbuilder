json.array!(@seasons) do |season|
  json.extract! season, :id, :start_date, :end_date
  json.url season_url(season, format: :json)
end

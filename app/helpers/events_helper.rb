module EventsHelper
  def time_for_json(time)
    tz = TZInfo::Timezone.get('America/New_York')
    tz.local_to_utc(time.to_datetime).rfc822
  end
end

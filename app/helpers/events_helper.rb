module EventsHelper
  def time_for_json(time)
    time_localized(time).rfc822
  end

  def time_for_ical(time)
    time.strftime("%Y%m%d")
  end

  def time_localized(time)
    tz = TZInfo::Timezone.get('America/New_York')
    tz.local_to_utc(time.to_datetime)
  end
end

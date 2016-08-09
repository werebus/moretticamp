module EventsHelper
  def time_for_ical(time)
    time.strftime('%Y%m%d')
  end
end

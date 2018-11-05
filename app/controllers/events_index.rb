# frozen_string_literal: true

module EventsIndex
  def html_index
    return unless @season
    @date = [@season.start_date, Date.today].max
  end

  def ics_index
    render plain: Event.ical(@events).to_ical, content_type: 'text/calendar'
  end

  def pdf_index
    if @season
      pdf = SeasonCalendar.new(@season, @events)
      pdf.generate
      send_data pdf.render,
                filename: 'camp_calendar.pdf',
                type: 'application/pdf'
    else
      redirect_to events_url, alert: 'No calendar to print.'
    end
  end
end

# frozen_string_literal: true

module EventsIndex
  def index
    @season = Season.current_or_next
    @events = EventsService.find(params)

    respond_to do |format|
      format.html { html_index }
      format.json
      format.ics { ics_index }
      format.pdf { pdf_index }
    end
  end

  def html_index
    return unless @season

    @date = [@season.start_date, Time.zone.today].max
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

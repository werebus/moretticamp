# frozen_string_literal: true

module EventsIndex
  def index
    @season = Season.current_or_next
    @pending_season = Season.current || Season.next if @season.blank?
    @events = EventsService.find(params)

    respond_to do |format|
      format.html
      format.json
      format.ics { ics_index }
      format.pdf { pdf_index }
    end
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
      redirect_to events_url, alert: t('.no_season')
    end
  end
end

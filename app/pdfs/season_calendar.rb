require 'prawn/measurement_extensions'

class SeasonCalendar
  include Prawn::View

  def initialize(season, events)
    @season = season
    @events = events
  end

  def document
    @document ||= Prawn::Document.new({
      page_layout: :landscape
    })
  end

  def generate
    months = @season.months
    months.each.with_index(1) do |month, i|
      month_page month
      start_new_page unless i == months.size
    end
  end

  private

  def month_page(month)
    text month.strftime('%B'), size: 22.pt, align: :center
    move_down 10.pt
    month_grid(month)
  end

  def month_grid(month)
    headers = Date::ABBR_DAYNAMES.map{ |dayname| make_cell(dayname) }

    leaders = month.wday.times.map{ box_cell(nil) }
    trailers = (6 - month.end_of_month.wday).times.map{ box_cell(nil) }

    days = (month..month.end_of_month).map do |day|
      day_cell day
    end

    cal_cells = (headers + leaders + days + trailers)
    table cal_cells.each_slice(7).to_a, row_colors: %w(FFFFFF EEEEEE)
  end

  def day_cell(day)
    events = @events.between(day, day).map(&:display_title)
    events << 'Camp Opens' if day == @season.start_date
    events << 'Camp Closes' if day == @season.end_date
    box_cell "#{day.day}\n" + events.join("\n")
  end

  def box_cell(content)
    make_cell(content: content, width: (10.0 / 7).in, height: (7.5 / 7).in)
  end
end

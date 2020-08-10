# frozen_string_literal: true

require 'prawn/measurement_extensions'

class MonthPage
  include Prawn::View

  attr_reader :document

  def initialize(document, month, season, dates)
    @document = document
    @month = month
    @season = season
    @dates = dates
  end

  def generate
    text @month.strftime('%B'), size: 22.pt, align: :center
    move_down 10.pt
    cal_cells = headers.concat(leaders, day_cells, trailers)
    table cal_cells.each_slice(7).to_a, row_colors: %w[FFFFFF EEEEEE]
  end

  private

  def box_cell(content)
    make_cell(content: content, width: (10.0 / 7).in, height: (7.5 / 7).in)
  end

  def headers
    Date::ABBR_DAYNAMES.map { |dayname| make_cell(dayname) }
  end

  def day_cells
    (@month..@month.end_of_month).map do |day|
      box_cell "#{day.day}\n" + @dates.fetch(day, []).join("\n")
    end
  end

  def leaders
    Array.new(@month.wday) { box_cell nil }
  end

  def trailers
    Array.new(6 - @month.end_of_month.wday) { box_cell nil }
  end
end

class SeasonCalendar
  include Prawn::View

  def initialize(season, events)
    @season = season
    @dates = @season.date_range.map do |date|
      [date, events.between(date, date).map(&:display_title)]
    end.to_h
    @dates[season.start_date].unshift('Camp Opens')
    @dates[season.end_date].unshift('Camp Closes')
  end

  def document
    @document ||= Prawn::Document.new(page_layout: :landscape)
  end

  def generate
    months = @season.months
    months.each.with_index(1) do |month, i|
      MonthPage.new(document, month, @season, @dates).generate
      start_new_page unless i == months.size
    end
  end
end

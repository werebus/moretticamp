# frozen_string_literal: true

class SeasonCalendar
  include Prawn::View

  def initialize(season, events)
    @season = season
    @dates = @season.date_range.index_with do |date|
      events.between(date, date).map(&:display_title)
    end
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

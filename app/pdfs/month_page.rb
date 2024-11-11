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
    make_cell(content:, width: (10.0 / 7).in, height: (7.5 / 7).in)
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

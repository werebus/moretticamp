# frozen_string_literal: true

require 'rails_helper'
require 'prawn/measurement_extensions'

RSpec.describe SeasonCalendar do
  let! :season do
    create :season
  end
  let! :event do
    create :event, :titled
  end
  let :pdf do
    SeasonCalendar.new(season, Event.all)
  end
  let :rendered_pdf do
    pdf.generate
    pdf.render
  end
  let :page_inspector do
    PDF::Inspector::Page.analyze rendered_pdf
  end
  let :text_inspector do
    PDF::Inspector::Text.analyze rendered_pdf
  end

  it 'is landscape-letter' do
    page_sizes = page_inspector.pages.pluck(:size)
    expect(page_sizes).to all(eq [11.in, 8.5.in])
  end

  it 'has a page for each month' do
    expect(page_inspector.pages.count).to be season.months.count
    expect(text_inspector.strings).to include(season.start_date.strftime('%B'))
    expect(text_inspector.strings).to include(season.end_date.strftime('%B'))
  end

  it 'has the opening and closing events' do
    expect(page_inspector.pages.first[:strings]).to include 'Camp Opens'
    expect(page_inspector.pages.last[:strings]).to include 'Camp Closes'
  end

  it 'has an event on it' do
    expect(text_inspector.strings).to include(event.display_title)
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'prawn/measurement_extensions'

RSpec.describe SeasonCalendar do
  subject :pdf do
    pdf = described_class.new(season, Event.all)
    pdf.generate
    pdf.render
  end

  let!(:season) { create :season }
  let!(:event) { create :event, :titled }
  let(:page_inspector) { PDF::Inspector::Page.analyze pdf }
  let(:text_inspector) { PDF::Inspector::Text.analyze pdf }

  it 'is landscape-letter' do
    page_sizes = page_inspector.pages.pluck(:size)
    expect(page_sizes).to all(eq [11.in, 8.5.in])
  end

  it 'has a page for each month' do
    expect(page_inspector.pages.count).to be season.months.count
  end

  it 'has a page for the first month' do
    expect(text_inspector.strings).to include(season.start_date.strftime('%B'))
  end

  it 'has a page for the last month' do
    expect(text_inspector.strings).to include(season.end_date.strftime('%B'))
  end

  it 'has the opening event' do
    expect(page_inspector.pages.first[:strings]).to include 'Camp Opens'
  end

  it 'has the closing event' do
    expect(page_inspector.pages.last[:strings]).to include 'Camp Closes'
  end

  it 'has an event on it' do
    expect(text_inspector.strings).to include(event.display_title)
  end
end

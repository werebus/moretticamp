# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventsController#index - calendar', js: true do
  let!(:season) { create :season, :now }
  let!(:event) { create :event, :now, title: 'LADYBUGS' }

  before do
    sign_in(create(:user))
    visit events_path
  end

  def with_calendar_buttons(&block)
    Capybara.enable_aria_label = true
    within('#calendar') { using_wait_time(0.2, &block) }
  end

  it 'starts on the current month' do
    header = find('#calendar .fc-header-toolbar .fc-left h2')
    expect(header).to have_content Time.zone.today.strftime('%B %Y')
  end

  it 'has an event on it' do
    within '#calendar .fc-body' do
      expect(page).to have_content event.display_title
    end
  end

  it 'has an link to the event on it' do
    within '#calendar .fc-body' do
      expect(page).to have_link href: /#{event_path(event)}/
    end
  end

  it 'limits navigation back to the season start' do
    with_calendar_buttons do
      click_on 'prev' until page.has_css? 'button.fc-prev-button[disabled]'
    end
    expect(page).to have_content season.start_date.strftime('%B %Y')
  end

  it 'limits navigation forward to the season end' do
    with_calendar_buttons do
      click_on 'next' until page.has_css? 'button.fc-next-button[disabled]'
    end
    expect(page).to have_content season.end_date.strftime('%B %Y')
  end

  it 'has a Camp open event on it' do
    with_calendar_buttons do
      click_on 'prev' until page.has_css? 'button.fc-prev-button[disabled]'
    end
    expect(page).to have_content 'Camp Opens'
  end

  it 'has a Camp close event on it' do
    with_calendar_buttons do
      click_on 'next' until page.has_css? 'button.fc-next-button[disabled]'
    end
    expect(page).to have_content 'Camp Closes'
  end
end

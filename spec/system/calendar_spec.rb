# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventsController#index - calendar', js: true do
  let! :season do
    create :season, :now
  end
  let! :event do
    create :event, :now, title: 'LADYBUGS'
  end

  before do
    sign_in(create(:user))
    visit events_path
  end

  it 'starts on the current month' do
    header = find('#calendar .fc-header-toolbar .fc-left h2')
    expect(header).to have_content Date.today.strftime('%B %Y')
  end

  it 'has an event on it' do
    within '#calendar .fc-body' do
      expect(page).to have_content event.display_title
      expect(page).to have_link href: /#{event_path(event)}/
    end
  end

  it 'limits navigation to the season' do
    Capybara.enable_aria_label = true
    within '#calendar' do
      using_wait_time 0.2 do
        click_on 'prev' until page.has_css? 'button.fc-prev-button[disabled]'
        expect(page).to have_content season.start_date.strftime('%B %Y')
        click_on 'next' until page.has_css? 'button.fc-next-button[disabled]'
        expect(page).to have_content season.end_date.strftime('%B %Y')
      end
    end
  end

  it 'has camp open and close events on it' do
    Capybara.enable_aria_label = true
    within '#calendar' do
      using_wait_time 0.2 do
        click_on 'prev' until page.has_css? 'button.fc-prev-button[disabled]'
        expect(page).to have_content 'Camp Opens'
        click_on 'next' until page.has_css? 'button.fc-next-button[disabled]'
        expect(page).to have_content 'Camp Closes'
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventsController#index' do
  let :user do
    create :user
  end
  before :each do
    sign_in(user)
  end

  it 'has a calendar feed url' do
    visit events_path
    feed_url = events_feed_url(token: user.calendar_access_token,
                               format: 'ics')

    expect(find_field('Calendar Feed URL').value).to eq feed_url
  end

  context 'without a season' do
    before :each do
      visit events_path
    end
    it 'tells the user to stay tuned' do
      expect(page).to have_content 'Season Not Open'
    end
    it 'does not load the calendar' do
      expect(page).not_to have_css '#calendar'
    end
    it 'does not show a link for new events' do
      expect(page).not_to have_content 'New Event'
    end
  end
  context 'with a season' do
    before :each do
      create :season
      visit events_path
    end
    it 'loads the calendar' do
      expect(page).to have_css '#calendar'
    end
    it 'shows a link for new events' do
      expect(page).to have_link href: new_event_path
    end
    it 'shows a link to print the season calendar' do
      expect(page).to have_link href: events_path(format: 'pdf')
    end
  end
  context 'as a non-admin' do
    before :each do
      visit events_path
    end
    it 'does not show a link to manage seasons' do
      expect(page).not_to have_content 'Manage Seasons'
    end
    it 'does not show a link to send notifications' do
      expect(page).not_to have_content 'Send Notification'
    end
  end
  context 'as an admin' do
    before :each do
      user.update_attribute(:admin, true)
      visit events_path
    end
    it 'shows a link to manage seasons' do
      expect(page).to have_link href: seasons_path
    end
    it 'shows a link to send notifications' do
      expect(page).to have_link href: new_notification_path
    end
  end
  context 'without invitations' do
    before :each do
      visit events_path
    end
    it 'does not show a link to invite a new user' do
      expect(page).not_to have_content 'Invite New User'
    end
  end
  context 'with invitations' do
    before :each do
      user.update_attribute(:invitation_limit, 1)
      visit events_path
    end
    it 'shows a link to invite a new user' do
      expect(page).to have_link href: new_user_invitation_path
    end
  end
end

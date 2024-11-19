# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventsController#index' do
  subject(:index) { page }

  let(:user) { create :user }

  before do
    sign_in(user)
    visit events_path
  end

  it 'has a calendar feed url' do
    feed_url = events_feed_url token: user.calendar_access_token,
                               format: 'ics',
                               host: URI.parse(page.current_url).host

    expect(page).to have_field('Calendar Feed URL', with: feed_url)
  end

  context 'without a season' do
    it { is_expected.to have_content('Season Not Open') }

    it { is_expected.to have_no_css('#calendar') }

    it { is_expected.to have_no_link('New Event') }
  end

  context 'with a season' do
    before do
      create :season, :now
      visit events_path
    end

    it { is_expected.to have_css('#calendar') }

    it { is_expected.to have_link('New Event') }

    it { is_expected.to have_link(href: events_path(format: 'pdf')) }
  end

  context 'when then user is not an admin' do
    it { is_expected.to have_no_link('Manage Seasons') }

    it { is_expected.to have_no_link('Send Notification') }
  end

  context 'when the user is an admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to have_link href: seasons_path }

    it { is_expected.to have_link href: new_notification_path }
  end

  context 'without invitations' do
    it { is_expected.to have_no_link 'Invite New User' }
  end

  context 'with invitations' do
    let(:user) { create :user, invitation_limit: 1 }

    it { is_expected.to have_link(href: new_user_invitation_path) }
  end
end

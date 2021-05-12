# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending notifications' do
  before do
    sign_in create(:user, admin: true)
    visit new_notification_path
    fill_in 'Subject', with: 'A Notification'
    fill_in 'Body', with: 'A *body*.'
  end

  it 'passes params along to the NotificationSenderJob' do
    allow(NotificationSenderJob).to receive(:perform_later).and_call_original
    click_on 'Send'
    expect(NotificationSenderJob).to have_received(:perform_later)
      .with(hash_including(subject: 'A Notification', body: 'A *body*.'))
  end

  it 'redirects to root and tells you notifications were queued' do
    click_on 'Send'
    expect(page).to have_current_path '/'
  end

  it 'tells you notifications were queued' do
    click_on 'Send'
    expect(page.find(:flash_type, :success)).to have_text(/Notifications queued /)
  end

  it 'Allows you to ignore user notification preference' do
    allow(NotificationSenderJob).to receive(:perform_later).and_call_original
    check 'Ignore'
    click_on 'Send'
    expect(NotificationSenderJob).to have_received(:perform_later)
      .with(hash_including(:override))
  end
end

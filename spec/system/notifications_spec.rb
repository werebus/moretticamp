# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending notifications' do
  let(:user) { create :user, admin: true }
  before :each do
    sign_in(user)
  end

  it 'passes params along to the NotificationService' do
    expect(NotificationSenderJob).to receive(:perform_later)
      .with(hash_including(subject: 'A Notification', body: 'A *body*.'))
      .and_call_original
    visit new_notification_path
    fill_in 'Subject', with: 'A Notification'
    fill_in 'Body', with: 'A *body*.'
    click_on 'Send'
  end

  it 'redirects to root and tells you notifications were queued' do
    visit new_notification_path
    fill_in 'Subject', with: 'A Notification'
    fill_in 'Body', with: 'A respectful message'
    click_on 'Send'
    expect(page.current_path).to eq '/'
    expect(page.find(:flash_type, :success)).to have_text(/Notifications queued /)
  end

  it 'Allows you to ignore user notification preference' do
    expect(NotificationSenderJob).to receive(:perform_later)
      .with(hash_including(:override))
      .and_call_original
    visit new_notification_path
    fill_in 'Subject', with: 'A Notification'
    fill_in 'Body', with: 'An urgent message'
    check 'Ignore'
    click_on 'Send'
  end
end

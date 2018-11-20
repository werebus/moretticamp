# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending notifications' do
  let :user do
    create :user, admin: true, email_updates: true
  end
  before :each do
    sign_in(user)
    create_list :user, 2, email_updates: false
  end

  it 'passes params along to the NotificationService' do
    expect(NotificationService).to receive(:send)
      .with(hash_including(subject: 'A Notification', body: 'A *body*.'))
      .and_call_original
    visit new_notification_path
    fill_in 'Subject', with: 'A Notification'
    fill_in 'Body', with: 'A *body*.'
    click_on 'Send'
  end

  context 'respecting user preferences' do
    it 'redirects to root and tells you how many notifications were sent' do
      visit new_notification_path
      fill_in 'Subject', with: 'A Notification'
      fill_in 'Body', with: 'A respectful message'
      click_on 'Send'
      expect(page.current_path).to eq '/'
      expect(page.find(:flash_type, :success)).to have_text(/1 notification /)
    end
  end
  context 'ignoring user preferences' do
    it 'redirects to root and tells you how many notifications were sent' do
      visit new_notification_path
      fill_in 'Subject', with: 'A Notification'
      fill_in 'Body', with: 'An urgent message'
      check 'Ignore'
      click_on 'Send'
      expect(page.current_path).to eq '/'
      expect(page.find(:flash_type, :success)).to have_text(/3 notifications /)
    end
  end
end

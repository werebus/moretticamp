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
    expect { click_on 'Send' }.to enqueue_job(NotificationSenderJob)
      .with(hash_including('subject' => 'A Notification', 'body' => 'A *body*.'))
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
    check 'Ignore'
    expect { click_on 'Send' }.to enqueue_job(NotificationSenderJob)
      .with(hash_including('override' => true))
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationService do
  describe '.send' do
    before :each do
      create_list :user, 2, email_updates: true
      create_list :user, 3, email_updates: false
    end
    let :dummy_mail_message do
      OpenStruct.new(deliver: true, deliver_now: true, deliver_later: true)
    end
    let :note_params do
      ActiveSupport::HashWithIndifferentAccess.new(
        subject: 'TEST EMAIL',
        body: '**Testing**',
        override: false
      )
    end

    it 'converts the body to HTML' do
      expect(NotificationMailer).to receive(:notification_email)
        .with(anything, anything, /<(strong|b)>Testing<\/\1>/)
        .at_least(:once)
        .and_return(dummy_mail_message)
      NotificationService.send(note_params)
    end
    it 'gives User.to_notify the override parameter' do
      expect(User).to receive(:to_notify)
        .with(true)
        .once.and_return([])
      expect(User).to receive(:to_notify)
        .with(false)
        .once.and_return([])
      NotificationService.send(note_params.merge(override: true))
      NotificationService.send(note_params.merge(override: false))
    end
    it 'sends a notification for each user who wants them' do
      expect(NotificationMailer).to receive(:notification_email)
        .twice.and_return(dummy_mail_message)
      NotificationService.send(note_params)
    end
    it 'sends a notification to all users if told to' do
      expect(NotificationMailer).to receive(:notification_email)
        .exactly(5).times
        .and_return(dummy_mail_message)
      NotificationService.send(note_params.merge(override: true))
    end
    it 'uses the subject given' do
      expect(NotificationMailer).to receive(:notification_email)
        .with(anything, 'TEST EMAIL', anything)
        .at_least(:once)
        .and_return(dummy_mail_message)
      NotificationService.send(note_params)
    end
    it 'returns the number of users notified' do
      allow(NotificationMailer).to receive(:notification_email)
        .and_return(dummy_mail_message)
      expect(NotificationService.send(note_params)).to be 2
    end
  end
end

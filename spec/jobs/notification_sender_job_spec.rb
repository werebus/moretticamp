# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationSenderJob do
  describe '.perform_later' do
    before :each do
      create_list :user, 2, email_updates: true
      create_list :user, 3, email_updates: false
    end

    let :note_params do
      { subject: 'TEST EMAIL', body: '**Testing**' }
    end
    let :dummy_mail_message do
      OpenStruct.new(deliver: true, deliver_now: true, deliver_later: true)
    end

    it 'enqueues a job' do
      expect { described_class.perform_later(note_params) }
        .to have_enqueued_job.on_queue('default')
    end

    context 'performing the job', perform_enqueued: true do
      it 'converts the body to HTML' do
        expect(NotificationMailer).to receive(:notification_email)
          .with(anything, anything, %r{<(strong|b)>Testing</\1>})
          .at_least(:once)
          .and_return(dummy_mail_message)
        described_class.perform_later(note_params)
      end

      it 'passes User.to_notify the override parameter' do
        expect(User).to receive(:to_notify)
          .with(override: true).once.and_return([])
        expect(User).to receive(:to_notify)
          .with(override: false).once.and_return([])

        described_class.perform_later(note_params.merge(override: true))
        described_class.perform_later(note_params.merge(override: false))
      end

      it 'sends a notification to each user who wants notifications' do
        expect(NotificationMailer).to receive(:notification_email)
          .twice.and_return(dummy_mail_message)

        described_class.perform_later(note_params)
      end

      it 'sends a notification to all users if told to' do
        expect(NotificationMailer).to receive(:notification_email)
          .exactly(5).times.and_return(dummy_mail_message)

        described_class.perform_later(note_params.merge(override: true))
      end

      it 'uses the subject given' do
        expect(NotificationMailer).to receive(:notification_email)
          .with(anything, 'TEST EMAIL', anything)
          .at_least(:once)
          .and_return(dummy_mail_message)
        described_class.perform_later(note_params)
      end
    end
  end
end

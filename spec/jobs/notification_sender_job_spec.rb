# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationSenderJob do
  describe '.perform_later' do
    before do
      create_list :user, 2, email_updates: true
      create_list :user, 3, email_updates: false
    end

    let(:note_params) { { subject: 'TEST EMAIL', body: 'BODY' } }
    let(:call) { described_class.perform_later(note_params) }

    it 'enqueues a job' do
      expect { call }.to have_enqueued_job.on_queue('default')
    end

    context 'performing the job', perform_enqueued: true do
      it 'wraps the body in a Kramdown Document' do
        expect(Kramdown::Document).to receive(:new)
          .with('BODY').and_call_original
        call
      end

      it 'passes along the body document' do
        allow(Kramdown::Document).to receive(:new).and_return(:a_document)
        expect(NotificationMailer).to receive(:notify)
          .with(anything, anything, :a_document)
          .at_least(:once).and_call_original
        call
      end

      [true, false].each do |bool|
        context "with a #{bool} override parameter" do
          let(:call) do
            described_class.perform_later(note_params.merge(override: bool))
          end

          it 'passes User.to_notify the override parameter' do
            expect(User).to receive(:to_notify)
              .with(override: bool).once.and_return([])
            call
          end
        end
      end

      it 'sends a notification to each user who wants notifications' do
        expect { described_class.perform_later(note_params) }
          .to change { ActionMailer::Base.deliveries.count }.by(2)
      end

      it 'sends a notification to all users if told to' do
        expect { described_class.perform_later(note_params.merge(override: true)) }
          .to change { ActionMailer::Base.deliveries.count }.by(5)
      end

      it 'uses the subject given' do
        expect(NotificationMailer).to receive(:notify)
          .with(anything, 'TEST EMAIL', anything)
          .at_least(:once).and_call_original
        described_class.perform_later(note_params)
      end
    end
  end
end

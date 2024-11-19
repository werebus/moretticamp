# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationSenderJob do
  describe '.perform_later' do
    subject(:call) { described_class.perform_later(**note_params) }

    before do
      create_list :user, 2, email_updates: true
      create_list :user, 3, email_updates: false
    end

    let(:base_params) { { subject: 'TEST EMAIL', body: 'BODY' } }
    let(:note_params) { base_params }

    it 'enqueues a job' do
      expect { call }.to have_enqueued_job.on_queue('default')
    end

    context 'when performing the job', :perform_enqueued do
      it 'wraps the body in a Kramdown Document' do
        allow(Kramdown::Document).to receive(:new).and_call_original
        call
        expect(Kramdown::Document).to have_received(:new).with('BODY')
      end

      it 'passes along the body document' do
        allow(Kramdown::Document).to receive(:new).and_return(:a_document)
        allow(NotificationMailer).to receive(:notify).and_call_original
        call
        expect(NotificationMailer).to have_received(:notify)
          .with(anything, anything, :a_document).at_least(:once)
      end

      it 'sends a notification to each user who wants notifications' do
        expect { call }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end

      context 'when overriding user preferences' do
        let(:note_params) { base_params.merge(override: true) }

        it 'sends a notification to all users' do
          expect { call }.to change { ActionMailer::Base.deliveries.count }.by(5)
        end
      end

      it 'uses the subject given' do
        allow(NotificationMailer).to receive(:notify).and_call_original
        call
        expect(NotificationMailer).to have_received(:notify)
          .with(anything, 'TEST EMAIL', anything).at_least(:once)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer do
  describe 'notification_email' do
    let(:user) { create :user }
    let(:mail) { described_class.notification_email(user, 'Subject', 'Body') }

    it 'has the correct headers' do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Subject')
      expect(mail.from).to eq(['noreply@moretti.camp'])
    end

    it 'has an HTML body' do
      expect(mail.content_type).to match(/^text\/html/)
      expect(mail.body.encoded).to include('Body')
    end
  end
end

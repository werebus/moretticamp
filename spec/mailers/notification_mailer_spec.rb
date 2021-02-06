# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer do
  describe 'notify' do
    let(:user) { create :user }
    let(:body) { 'BODY' }
    let(:mail) { described_class.notify(user, 'Subject', body) }

    it 'is addressed to the user' do
      expect(mail.to).to eq([user.email])
    end

    it 'has the correct subject' do
      expect(mail.subject).to eq('Subject')
    end

    it 'is from the noreply address' do
      expect(mail.from).to eq(['noreply@moretti.camp'])
    end

    context 'with a plain string body' do
      it 'is plain text' do
        expect(mail.content_type).to start_with('text/plain')
      end

      it 'has the expected body' do
        expect(mail.body.encoded).to eq(body)
      end
    end

    context 'with a Kramdown document body' do
      let(:body) { Kramdown::Document.new('**BODY**') }
      let(:html) { mail.html_part.body.encoded }
      let(:plain) { mail.text_part.body.encoded }

      it 'is multipart' do
        expect(mail).to be_multipart
      end

      it 'has an HTML part with parsed Markdown' do
        expect(html).to include('<strong>BODY</strong>')
      end

      it 'has a plain part with unparsed Markdown' do
        expect(plain).to include('**BODY**')
      end
    end
  end
end

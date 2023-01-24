# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ICS feed' do
  let(:user) { create :user }

  context 'with a valid token' do
    before { get "/feed/#{user.calendar_access_token}.ics" }

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'has the correct content type' do
      expect(response.media_type).to eq 'text/calendar'
    end

    it 'contains an iCal document' do
      expect(response.body.lines.first).to eq "BEGIN:VCALENDAR\r\n"
    end
  end

  context 'with an invalid token' do
    before { get "/feed/#{SecureRandom.hex}.ics" }

    it 'prohibits access' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when the user is logged in' do
    before do
      sign_in user
      get events_path(format: 'ics')
    end

    it 'allows access' do
      expect(response).to have_http_status(:ok)
    end

    it 'has the correct content type' do
      expect(response.media_type).to eq 'text/calendar'
    end

    it 'contains an iCal document' do
      expect(response.body.lines.first).to eq "BEGIN:VCALENDAR\r\n"
    end
  end
end

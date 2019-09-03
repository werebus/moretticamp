# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ICS feed' do
  let :user do
    create :user
  end

  it 'renders an ics feed with a valid token' do
    get "/feed/#{user.calendar_access_token}.ics"
    expect(response.status).to eq 200
    expect(response.media_type).to eq 'text/calendar'
    expect(response.body.lines.first).to eq "BEGIN:VCALENDAR\r\n"
  end

  it 'prohibits access without a valid token' do
    get "/feed/#{SecureRandom.hex}.ics"
    expect(response.status).to eq 401
  end

  it 'is accesable at the events index as well' do
    sign_in(user)
    get events_path(format: 'ics')
    expect(response.status).to eq 200
    expect(response.media_type).to eq 'text/calendar'
    expect(response.body.lines.first).to eq "BEGIN:VCALENDAR\r\n"
  end
end

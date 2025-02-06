# frozen_string_literal: true

require 'rails_helper'
require 'nokogiri'

RSpec.describe VoiceController do
  def response_content(css)
    Nokogiri::XML(response.body).css(css)
  end

  let :valid_call_params do
    { AccountSid: 'AC0123456789abcdef0123456789abcdef',
      From: '+15005550006' }
  end

  let(:webhook_path) { voice_events_path(format: :xml) }
  let(:params) { valid_call_params }
  let(:first_speech) { response_content('Say').first.text }
  let!(:season) { create :season }

  around do |example|
    date = Time.zone.now.to_date.change(month: 4, day: 15)
    Timecop.travel(date) { example.run }
  end

  before do
    Rails.application.credentials.twilio_account_sid = valid_call_params[:AccountSid]
    Rails.application.credentials.camp_phone_number = valid_call_params[:From]
    FactoryBot.reload
    create_list :event, 5, :sequenced
    post webhook_path, params:
  end

  it 'allows unauthenticated access' do
    expect(response).to have_http_status(:ok)
  end

  it 'sets the content type to XML' do
    expect(response.media_type).to eq 'application/xml'
  end

  it 'has a root <Response> element' do
    expect(response_content('Response')).to be_present
  end

  it 'allows calls from the configured number' do
    expect(response_content('Response > *').first.name).not_to eq 'Reject'
  end

  context 'when the call is from another number' do
    let(:params) { valid_call_params.merge(From: '+15005550001') }

    it 'rejects calls' do
      expect(response_content('Response > *').first.name).to eq 'Reject'
    end
  end

  context 'when the call is from another Twillio account' do
    let(:params) do
      valid_call_params.merge(AccountSid: 'ACbad555bad555bad555bad555bad555bd')
    end

    it 'rejects calls' do
      expect(response_content('Response > *').first.name).to eq 'Reject'
    end
  end

  { /repeat/ => '1', /next event/ => '2', /start over/ => '3' }.each do |item, n|
    it "has a menu item for #{item}" do
      item = response_content('Say').find { |say| say.text =~ item && say.text =~ /press #{n}/ }
      expect(item).to be_present
    end
  end

  it 'starts with the next event after today' do
    event = Event.next
    expect(first_speech).to include(event.display_title)
  end

  it 'repeats the event when 1 is pressed' do
    post webhook_path, params: valid_call_params.merge(Digits: '1')

    event = Event.next
    expect(first_speech).to include(event.display_title)
  end

  it 'moves on to the next event when 2 is pressed' do
    post webhook_path, params: valid_call_params.merge(Digits: '2')

    event = Event.excluding(Event.next).next_after(Time.zone.today)
    expect(first_speech).to include(event.display_title)
  end

  it 'starts over at the beginning when 3 is pressed' do
    post webhook_path, params: valid_call_params.merge(Digits: '2')
    post webhook_path, params: valid_call_params.merge(Digits: '2')
    post webhook_path, params: valid_call_params.merge(Digits: '3')

    event = Event.next
    expect(first_speech).to include(event.display_title)
  end

  it 'informs the caller when they are at the end' do
    event_count = Event.between(Time.zone.today, season.end_date).count
    event_count.times do
      post webhook_path, params: valid_call_params.merge(Digits: '2')
    end

    expect(first_speech).to include('no further events')
  end

  it 'says goodbye' do
    goodbye = response_content('Say').select { |tag| tag.text =~ /Goodbye/ }
    expect(goodbye).to be_present
  end

  it 'hangs up' do
    hangup = response_content('Hangup')
    expect(hangup).to be_present
  end
end

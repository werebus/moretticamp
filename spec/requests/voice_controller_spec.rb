# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/webhookable'

RSpec.describe VoiceController do
  include_context 'with twilio'

  let(:webhook_path) { voice_events_path }
  let(:first_speech) { response_document.css('Say').first.text }
  let!(:season) { create :season }
  let(:says) { response_document.css('Say') }

  around do |example|
    date = Time.zone.now.to_date.change(month: 4, day: 15)
    Timecop.travel(date) { example.run }
  end

  before do
    FactoryBot.reload
    create_list :event, 5, :sequenced
    post webhook_path, params: valid_call_params
  end

  it_behaves_like 'a webhookable controller'

  { /repeat/ => '1', /next event/ => '2', /start over/ => '3' }.each do |item, n|
    it "has a menu item for #{item}" do
      item = says.find { |say| say.text =~ item && say.text =~ /press #{n}/ }
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
    goodbye = response_document.css('Say').select { |tag| tag.text =~ /Goodbye/ }
    expect(goodbye).to be_present
  end

  it 'hangs up' do
    hangup = response_document.css('Hangup')
    expect(hangup).to be_present
  end
end

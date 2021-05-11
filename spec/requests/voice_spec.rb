# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/webhookable'

RSpec.describe VoiceController do
  include_context 'with_twilio'

  let(:webhook_path) { voice_events_path }
  let :first_speech do
    response_document.css('Say').first.text
  end

  around do |example|
    date = Time.zone.local(Date.today.year, 4, 15)
    Timecop.travel(date) do
      example.run
    end
  end

  before do
    FactoryBot.reload
    @season = create :season
    create_list(:event, 5, :sequenced)

    post webhook_path, params: valid_call_params
  end

  it_behaves_like 'a_webhookable_controller'

  it 'gives the caller a menu' do
    says = response_document.css('Say')
    menu_items = { /repeat/ => '1', /next event/ => '2', /start over/ => '3' }

    menu_items.each do |pattern, digit|
      item = says.find do |say|
        say.text =~ pattern && say.text =~ /press #{digit}/
      end
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

  it 'moves onto the next event when 2 is pressed' do
    post webhook_path, params: valid_call_params.merge(Digits: '2')

    event = Event.next_after(Date.today, [Event.next.id])
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
    event_count = Event.between(Date.today, @season.end_date).count
    event_count.times do
      post webhook_path, params: valid_call_params.merge(Digits: '2')
    end

    expect(first_speech).to include('no further events')
  end

  it 'says goodbye and hangs up' do
    goodbye = response_document
              .css('Say').select { |tag| tag.text =~ /Goodbye/ }
    hangup = response_document.css('Hangup')

    expect(goodbye).to be_present
    expect(hangup).to be_present
  end
end

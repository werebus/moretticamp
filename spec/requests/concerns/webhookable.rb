# frozen_string_literal: true

require 'nokogiri'
require 'rails_helper'

shared_context 'with_twilio' do
  before :all do
    ENV['TWILIO_ACCOUNT_SID'] = 'AC0123456789abcdef0123456789abcdef'
    ENV['CAMP_PHONE_NUMBER'] = '+15005550006'
  end

  let :valid_call_params do
    {
      AccountSid: 'AC0123456789abcdef0123456789abcdef',
      From: '+15005550006'
    }
  end

  let :response_document do
    Nokogiri::XML(response.body)
  end
end

shared_examples_for 'a_webhookable_controller' do
  include_context 'with_twilio'

  let :first_response_element do
    response_document.css('Response > *').first
  end

  it 'allows unauthenticated access' do
    post webhook_path

    expect(response.status).to eq 200
  end

  it 'renders TwiML correctly' do
    post webhook_path

    expect(response.content_type).to eq 'application/xml'
    expect(response_document.xml?).to be true
    expect(first_response_element).to be_present
  end

  it 'allows calls from the configured number' do
    post webhook_path, params: valid_call_params

    expect(first_response_element.name).not_to eq 'Reject'
  end

  it 'rejects calls from other numbers' do
    post webhook_path, params: valid_call_params.merge({
        From: '+15005550001'
    })

    expect(first_response_element.name).to eq 'Reject'
  end

  it 'rejects calls from other Twilio accounts' do
    post webhook_path, params: valid_call_params.merge({
        AccountSid: 'ACbad555bad555bad555bad555bad555bd'
      })

    expect(first_response_element.name).to eq 'Reject'
  end
end

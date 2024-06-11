# frozen_string_literal: true

require 'nokogiri'
require 'rails_helper'

RSpec.shared_context 'with twilio' do
  before do
    Rails.application.credentials.twilio_account_sid = 'AC0123456789abcdef0123456789abcdef'
    Rails.application.credentials.camp_phone_number = '+15005550006'
  end

  let :valid_call_params do
    { AccountSid: 'AC0123456789abcdef0123456789abcdef',
      From: '+15005550006' }
  end

  let(:response_document) { Nokogiri::XML(response.body) }
end

RSpec.shared_examples_for 'a webhookable controller' do
  include_context 'with twilio'

  let :first_response_element do
    response_document.css('Response > *').first
  end
  let(:params) { valid_call_params }

  before { post webhook_path, params: params }

  it 'allows unauthenticated access' do
    expect(response).to have_http_status(:ok)
  end

  it 'sets the content type to XML' do
    expect(response.media_type).to eq 'application/xml'
  end

  it 'contains valid XML' do
    expect(response_document.xml?).to be true
  end

  it 'has a root <Response> element' do
    expect(first_response_element).to be_present
  end

  it 'allows calls from the configured number' do
    expect(first_response_element.name).not_to eq 'Reject'
  end

  context 'when the call is from another number' do
    let(:params) { valid_call_params.merge(From: '+15005550001') }

    it 'rejects calls' do
      expect(first_response_element.name).to eq 'Reject'
    end
  end

  context 'when the call is from another Twillio account' do
    let(:params) do
      valid_call_params.merge(AccountSid: 'ACbad555bad555bad555bad555bad555bd')
    end

    it 'rejects calls' do
      expect(first_response_element.name).to eq 'Reject'
    end
  end
end

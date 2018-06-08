# frozen_string_literal: true

module Webhookable
  extend ActiveSupport::Concern

  included do
    before_action :require_valid_source
    after_action :set_header
    skip_before_action :verify_authenticity_token, :authenticate_user!
  end

  def valid_call?
    params.permit(%i[AccountSid From]).to_h.values ==
      ENV.values_at('TWILIO_ACCOUNT_SID', 'CAMP_PHONE_NUMBER')
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end

  def render_twiml(response)
    render body: response.to_s
  end

  def require_valid_source
    return if Rails.env.development? || valid_call?
    reject_call!
  end

  def reject_call!
    response = Twilio::TwiML::VoiceResponse.new.reject
    set_header
    render_twiml response
  end
end

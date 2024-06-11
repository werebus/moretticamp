# frozen_string_literal: true

module Webhookable
  extend ActiveSupport::Concern

  included do
    before_action :require_valid_source
    skip_before_action :verify_authenticity_token, :authenticate_user!
  end

  def valid_call?
    params.permit(%i[AccountSid From]).to_h.values ==
      [Rails.application.credentials.twilio_account_sid, Rails.application.credentials.camp_phone_number]
  end

  def render_twiml(response)
    render xml: response.to_xml
  end

  def require_valid_source
    return if Rails.env.development? || valid_call?

    reject_call!
  end

  def reject_call!
    render_twiml Twilio::TwiML::VoiceResponse.new.reject
  end
end

module Webhookable
  extend ActiveSupport::Concern

  included do
    before_filter :require_valid_source
    after_filter :set_header
    skip_before_action :verify_authenticity_token, :authenticate_user!
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end

  def render_twiml(response)
    render text: response.text
  end

  def require_valid_source
    unless Rails.env.development? || params.values_at(:AccountSid, :From) == ENV.values_at('TWILIO_ACCOUNT_SID', 'CAMP_PHONE_NUMBER')
      reject_call!
    end
  end

  def reject_call!
    response = Twilio::TwiML::Response.new{ |r| r.Reject }
    set_header
    render_twiml response
  end
end

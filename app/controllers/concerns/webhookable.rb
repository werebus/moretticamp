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
    unless Rails.env.development? ||
      ( params[:AccountSid] == ENV['TWILIO_ACCOUNT_SID'] && params[:From] == ENV['CAMP_PHONE_NUMBER'])
      response = Twilio::TwiML::Response.new do |r|
        r.Reject
      end

      render_twiml response and return
    end
  end
end

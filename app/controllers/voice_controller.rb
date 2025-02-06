# frozen_string_literal: true

class VoiceController < ApplicationController
  before_action :require_valid_source
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def events
    @event = Event.where.not(id: exclude).next_after(Time.zone.today)

    session[:exclude] = exclude
    session[:event] = @event.try :id
    render xml: event_twiml.to_xml
  end

  private

  def require_valid_source
    return if Rails.env.development? || valid_call?

    render xml: Twilio::TwiML::VoiceResponse.new.reject.to_xml
  end

  def valid_call?
    params.permit(%i[AccountSid From]).to_h.values ==
      [Rails.application.credentials.twilio_account_sid, Rails.application.credentials.camp_phone_number]
  end

  def exclude
    @exclude ||= session[:exclude] || [0]
    @exclude << session[:event] if pressed? 2
    @exclude = [0] if pressed? 3
    @exclude
  end

  def pressed
    @pressed ||= params[:Digits].try :to_i
  end

  def pressed?(*nums)
    nums.include? pressed
  end

  def say_event(event)
    "The next event scheduled #{'after that' if exclude.length > 1} is " \
      "#{event.display_title}  #{event.date_range_readable}."
  end

  def say(resp, message)
    resp.say message:, voice: 'alice'
  end

  # rubocop:disable Metrics/MethodLength
  def event_twiml
    Twilio::TwiML::VoiceResponse.new do |r|
      if pressed?(nil, 1, 2, 3)
        r.gather(num_digits: 1) do |g|
          if @event
            say(g, say_event(@event))
            g.pause
            say(g, 'To repeat that, press 1.')
            say(g, 'To hear the next event, press 2.')
          else
            say(g, 'There are no further events scheduled.')
          end

          say(g, 'To start over, press 3.')
        end
      end
      say(r, 'Goodbye!')
      r.hangup
    end
  end
  # rubocop:enable Metrics/MethodLength
end

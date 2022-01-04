# frozen_string_literal: true

class VoiceController < ApplicationController
  include Webhookable

  def events
    @event = Event.next_after(Time.zone.today, exclude)
    twiml_response = event_twiml

    session[:exclude] = exclude
    session[:event] = @event.try :id
    render_twiml twiml_response
  end

  private

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
    resp.say message: message, voice: 'alice'
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

# frozen_string_literal: true

class VoiceController < ApplicationController
  include Webhookable

  def events
    @pressed = (params[:Digits].present? ? params[:Digits].to_i : nil)

    @exclude = session[:exclude] || [0]
    @exclude << session[:event] if @pressed == 2
    @exclude = [0] if @pressed == 3

    @event = Event.next_after(Date.today, @exclude)
    session[:event] = @event.try(:id)
    session[:exclude] = @exclude

    say_options = { voice: 'alice' }
    response = Twilio::TwiML::VoiceResponse.new do |r|
      if [nil, 1, 2, 3].include? @pressed
        r.gather(num_digits: 1) do |g|
          if @event
            g.say 'The next event scheduled' \
                  "#{@exclude.length > 1 ? 'after that' : ''} is",
                  say_options
            g.say "#{@event.display_title}  #{@event.date_range_readable}.",
                  say_options
            g.pause
            g.say 'To repeat that, press 1.', say_options
            g.say 'To hear the next event, press 2.', say_options
          else
            g.say 'There are no further events scheduled.', say_options
          end

          g.say 'To start over, press 3.', say_options
        end
      end
      r.say 'Goodbye!', say_options
      r.hangup
    end

    render_twiml response
  end
end

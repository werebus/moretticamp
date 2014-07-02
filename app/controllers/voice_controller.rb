class VoiceController < ApplicationController
  include Webhookable

  def events
    @pressed = (params[:Digits].present? ? params[:Digits].to_i : nil)

    @exclude = session[:exclude] || [0]
    @exclude << session[:event] if @pressed == 2
    @exclude = [0] if @pressed == 3

    @event = Event.next_after( Date.today, @exclude )
    session[:event] = @event.try(:id)
    session[:exclude] = @exclude

    say_options = {voice: 'alice'}
    response = Twilio::TwiML::Response.new do |r|
      if [nil, 1, 2, 3].include? @pressed
        r.Gather(numDigits: 1) do |g|
          if @event
            g.Say "The next event scheduled #{@exclude.length > 1 ? 'after that' : ''} is", say_options
            g.Say @event.display_title + " " + @event.date_range_readable + ".", say_options
            g.Pause
            g.Say "To repeat that, press 1.", say_options
            g.Say "To hear the next event, press 2.", say_options
          else
            g.Say "There are no further events scheduled.", say_options
          end

          g.Say "To start over, press 3.", say_options
        end
      end
      r.Say "Goodbye!", say_options
      r.Hangup
    end

    render_twiml response
  end
end

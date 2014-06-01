class VoiceController < ApplicationController
  include Webhookable

  def events
    @exclude = session[:exclude] || [0]
    @exclude << session[:event] if (params[:Digits].to_i) == 2
    @exclude = [0] if (params[:Digits].to_i) == 3

    @event = Event.next_after( Date.today, @exclude )
    session[:event] = @event.id
    session[:exclude] = @exclude

    response = Twilio::TwiML::Response.new do |r|
      if params[:Digits].nil? || [1, 2, 3].include?(params[:Digits].to_i)
        r.Gather(numDigits: 1) do |g|
          g.Say "The next event scheduled #{@exclude.length > 1 ? 'after that' : ''} is"
          g.Say @event.display_title + " " + @event.date_range_readable + "."
          g.Say "To repeat that, press 1."
          g.Say "To hear the next event, press 2."
          g.Say "To start over, press 3."
        end
      end
      r.Say "Goodbye"
      r.Hangup
    end

    render_twiml response
  end
end

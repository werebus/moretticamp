# frozen_string_literal: true

module VoiceHelper
  def voice_event_description(event, first: false)
    "The next event scheduled #{'after that' unless first} is " \
      "#{event.display_title}  #{event.date_range_readable}."
  end
end

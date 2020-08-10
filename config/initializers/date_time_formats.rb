# frozen_string_literal: true

Time::DATE_FORMATS[:ics] = ->(time) { time.utc.strftime '%Y%m%dT%H%M%SZ' }

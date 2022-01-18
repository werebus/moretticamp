# frozen_string_literal: true

Time::DATE_FORMATS[:ics] = ->(time) { time.utc.strftime '%Y%m%dT%H%M%SZ' }

Date::DATE_FORMATS[:unix] = ->(date) { date.to_time(:local).to_i }
Date::DATE_FORMATS[:short_ordinal] = lambda { |date|
  day_format = ActiveSupport::Inflector.ordinalize(date.day)
  date.strftime "%b #{day_format}"
}
Date::DATE_FORMATS[:long_ordinal] = lambda { |date|
  day_format = ActiveSupport::Inflector.ordinalize(date.day)
  date.strftime "%A, %B #{day_format}"
}

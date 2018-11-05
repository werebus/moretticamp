# frozen_string_literal: true

module EventsService
  class << self
    def find(params)
      if params[:start] && params[:end]
        start_time = Date.parse(params[:start])
        end_time = Date.parse(params[:end])
        Event.between(start_time, end_time)
      else
        Event.all
      end
    end
  end
end

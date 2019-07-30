# frozen_string_literal: true

module EventsService
  class << self
    def find(params)
      if params[:start] && params[:end]
        start_time = Date.parse(params[:start])
        end_time = Date.parse(params[:end])
        Event.includes(:user).between(start_time, end_time)
      else
        Event.includes(:user)
      end
    end
  end
end

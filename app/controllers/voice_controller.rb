# frozen_string_literal: true

class VoiceController < ApplicationController
  before_action :require_valid_source
  skip_before_action :verify_authenticity_token, :authenticate_user!

  helper_method :exclude, :pressed?

  def events
    @event = Event.where.not(id: exclude).next_after(Time.zone.today)

    session[:exclude] = exclude
    session[:event] = @event.try :id
  end

  private

  def require_valid_source
    return if Rails.env.development? || valid_call?

    render 'reject'
  end

  def valid_call?
    params.permit(%i[AccountSid From]).to_h.values ==
      [Rails.application.credentials.twilio_account_sid, Rails.application.credentials.camp_phone_number]
  end

  def exclude
    return @exclude = [0] if pressed? 3

    @exclude ||= (session[:exclude] || [0]).tap do |e|
      e << session[:event] if pressed? 2
    end
  end

  def pressed?(*nums)
    nums.include?(@pressed ||= params[:Digits]&.to_i)
  end
end

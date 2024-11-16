# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :require_admin

  def create
    params.require %i[subject body]
    permitted = params.permit(%i[subject body override]).to_h.symbolize_keys.tap do |p|
      p[:override] = p[:override] == '1'
    end

    NotificationSenderJob.perform_later(**permitted)
    flash.notice = 'Notifications queued for delivery'
    redirect_to root_path
  end
end

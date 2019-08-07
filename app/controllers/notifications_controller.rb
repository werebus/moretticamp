# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :require_admin

  def create
    params.require %i[subject body]
    permitted = params.permit(%i[subject body override]).to_h.symbolize_keys

    NotificationSenderJob.perform_later(permitted)
    flash.notice = 'Notifications queued for delivery'
    redirect_to '/'
  end
end

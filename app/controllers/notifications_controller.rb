# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :require_admin

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)

    if @notification.valid?
      NotificationSenderJob.perform_later(**@notification.attributes.symbolize_keys)
      redirect_to root_path, notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def notification_params
    params.expect(notification: %i[subject body override])
  end
end

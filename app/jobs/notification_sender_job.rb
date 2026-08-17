# frozen_string_literal: true

class NotificationSenderJob < ApplicationJob
  def perform(notification_attributes)
    notification = Notification.new(notification_attributes)
    document = Kramdown::Document.new(notification.body)
    users = User.to_notify(override: notification.override?)
    users.find_each do |user|
      NotificationMailer.notify(user, notification.subject, document).deliver_now
    end
  end
end

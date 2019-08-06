# frozen_string_literal: true

class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform(subject:, body:, override: false)
    body = Kramdown::Document.new(body).to_html
    users = User.to_notify(override)
    users.each do |user|
      m = NotificationMailer.notification_email(user, subject, body)
      m.deliver_now
    end.count
  end
end

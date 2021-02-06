# frozen_string_literal: true

class NotificationSenderJob < ApplicationJob
  def perform(subject:, body:, override: false)
    document = Kramdown::Document.new(body)
    users = User.to_notify(override: override)
    users.each do |user|
      m = NotificationMailer.notify(user, subject, document)
      m.deliver_now
    end
  end
end

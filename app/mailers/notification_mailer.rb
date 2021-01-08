# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notification_email(user, subject, body)
    mail to: user.email,
         subject: subject,
         body: body,
         content_type: 'text/html'
  end
end

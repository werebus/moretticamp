class NotificationMailer < ActionMailer::Base
  default from: 'noreply@moretti.camp'

  def notification_email(user, subject, body)
    mail to: user.email,
         subject: subject,
         body: body
  end
end

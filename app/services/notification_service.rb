# frozen_string_literal: true

module NotificationService
  class << self
    def send(params)
      body = Kramdown::Document.new(params[:body]).to_html
      users = User.to_notify params[:override].present?
      users.each do |user|
        m = NotificationMailer.notification_email(user, params[:subject], body)
        m.deliver_now
      end.count
    end
  end
end

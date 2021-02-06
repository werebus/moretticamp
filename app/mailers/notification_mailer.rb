# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify(user, subject, document)
    mail(to: user.email, subject: subject) do |format|
      case document
      when Kramdown::Document
        format.html { render html: document.to_html.html_safe }
        format.text { render plain: document.to_kramdown }
      when String
        format.text { render plain: document }
      end
    end
  end
end

# frozen_string_literal: true

class NotificationMailerPreview < ActionMailer::Preview
  def notify
    user = User.first
    subject = 'Test Subject'
    NotificationMailer.notify(user, subject, Kramdown::Document.new(body))
  end

  private

  def body
    Array.new(5) do
      case rand(6)
      when 0
        Faker::Markdown.random('table')
      when 1
        '[Link](https://example.com)'
      else
        Faker::Lorem.paragraph
      end
    end.join("\n\n")
  end
end

# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@moretti.camp'
  layout 'mailer'
  helper_method :hemlock_src

  private

  def hemlock_src
    attachments['hemlockcone.png'] = Rails.root.join('app/assets/images/hemlockcone.png').read
    attachments['hemlockcone.png'].url
  end
end

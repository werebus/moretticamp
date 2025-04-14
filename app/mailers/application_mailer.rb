# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@moretti.camp'
  layout 'mailer'
  before_action :attach_hemlock

  def attach_hemlock
    attachments['hemlockcone.png'] = Rails.root.join('app/assets/images/hemlockcone.png').read
  end
end

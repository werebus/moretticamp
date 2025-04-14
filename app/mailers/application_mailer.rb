# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@moretti.camp'
  layout 'mailer'
end

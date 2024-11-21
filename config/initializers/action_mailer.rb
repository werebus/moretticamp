# frozen_string_literal: true

options = { region: 'us-east-1' }
ActionMailer::Base.add_delivery_method :ses, Aws::ActionMailer::SES::Mailer, **options

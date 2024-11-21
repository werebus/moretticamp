# frozen_string_literal: true

aws_credential_keys = %i[access_key_id secret_access_key session_token account_id]
creds = Rails.application.credentials[:aws].to_h.slice(*aws_credential_keys)

options = creds.merge({ region: 'us-east-1' })
ActionMailer::Base.add_delivery_method :ses, Aws::ActionMailer::SES::Mailer, **options

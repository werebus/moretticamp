# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def no_reset(user)
    @user = user
    @reason = invited_reason || oauth_reason

    mail to: user.email, subject: 'Password reset not performed'
  end

  private

  def invited_reason
    return unless @user.invited_to_sign_up?

    <<~REASON.squish
      You haven't yet accepted your invitation to the site and so do not have a
      password to reset. Please click the link in the invitation email to create
      a password. If you need a new invitation, please contact the site
      administrator.
    REASON
  end

  def oauth_reason
    return if @user.provider.blank?

    provider = @user.provider_name
    <<~REASON.squish
      Your account on moretti.camp is associated with your #{provider} account.
      You don't need a password to log in, simply click the #{provider} logo on
      the sign-in page.
    REASON
  end
end

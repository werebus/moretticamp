class UserMailer < ActionMailer::Base
  default from: 'noreply@moretti.camp'

  def no_reset(user, reason)
    @user = user
    oauth_provider = OAUTH_PROVIDERS.find { |oap| oap.label == user.provider.to_sym } .name if user.provider.present?
    @reason = case reason
              when :invited
                invited_reason
              when :oauth
                oath_reason(oauth_provider)
              end

    mail to: user.email,
         subject: 'Password reset not performed'
  end

  private

  def clean(string)
    string.gsub(/^ +/, '').strip
  end

  def invited_reason
    clean(<<-EOS)
      You haven't yet accepted your invitation to the site and so do not have a password
      to reset. Please click the link in the invitation email to create a password. If
      you need a new invitation, please contact the site administrator.
    EOS
  end

  def oauth_reason(provider)
    clean(<<-EOS)
      Your account on moretti.camp is associated with your #{provider} account. You
      don't need a password to log in, simply click the #{provider} logo on the
      sign-in page.
    EOS
  end
end

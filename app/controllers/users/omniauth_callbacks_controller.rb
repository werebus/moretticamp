# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    OauthProvider.all.each do |oap|
      define_method(oap.label) do
        omniauth_callback(oap.name)
      end
    end

    private

    def omniauth_callback(name)
      auth = request.env['omniauth.auth']
      identity = User.find_for_oath(auth)

      if identity
        sign_in_and_redirect(identity, event: :authentication)
        report_success name
      else
        token = session[:invitation_token]
        # Not a dynamic finder, defined in devise_invitable
        # rubocop:disable  Rails/DynamicFindBy
        user = User.find_by_invitation_token(token, true)
        # rubocop:enable  Rails/DynamicFindBy
        if user
          accept_invite(user, auth)
          report_success name
        else
          redirect_to new_user_session_path
        end
      end
    end

    def accept_invite(user, auth)
      session[:invitation_token] = nil
      user.accept_invitation!
      user.update(provider: auth.provider, uid: auth.uid)
      sign_in_and_redirect(user, event: :authentication)
    end

    def report_success(name)
      return unless is_navigational_format?

      set_flash_message(:notice, :success, kind: name)
    end
  end
end

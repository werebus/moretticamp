class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider, name)
    define_method(provider) do
      auth = request.env["omniauth.auth"]
      identity = User.find_for_oath(auth)

      if identity
        sign_in_and_redirect(identity, :event => :authentication)
        set_flash_message(:notice, :success, :kind => name) if is_navigational_format?
      else
        token = session[:invitation_token]
        if token && user = User.find_by_invitation_token(token, true)
          session[:invitation_token] = nil
          user.accept_invitation!
          user.update_attributes(auth.slice(:provider, :uid))
          sign_in_and_redirect(user, :event => :authentication)
          set_flash_message(:notice, :success, :kind => name) if is_navigational_format?
        else
          redirect_to new_user_session_path
        end
      end

    end
  end

  OAUTH_PROVIDERS.each do |oap|
    provides_callback_for oap.label, oap.name
  end
end

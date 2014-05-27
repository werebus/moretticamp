class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def generic_provider
    auth = request.env["omniauth.auth"]
    identity = User.find_for_oath(auth)

    if identity
      sign_in_and_redirect(identity, :event => :authentication)
      set_flash_message(:notice, :success, :kind => "OAuth") if is_navigational_format?
    else
      token = session[:invitation_token]
      if token && user = User.find_by_invitation_token(token, true)
        session[:invitation_token] = nil
        user.accept_invitation!
        user.update_attributes(auth.slice(:provider, :uid))
        sign_in_and_redirect(user, :event => :authentication)
        set_flash_message(:notice, :success, :kind => "OAuth") if is_navigational_format?
      else
        redirect_to new_user_session_path
      end
    end
  end

  alias_method :google_oauth2, :generic_provider
end

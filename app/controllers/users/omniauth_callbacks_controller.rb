class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def generic_provider
    auth = request.env["omniauth.auth"]
    identity = User.find_for_oath(auth)

    if identity
      sign_in(identity)
    else
      token = session[:invitation_token]
      if token && user = User.where(invitation_token: token).first
        user.accept_invitation!
        user.apply_omniauth(auth)
        sign_in(user)
      else
        redirect_to_after_signout_path_for(resource_name)
      end
    end
  end

  alias_method :google, :generic_provider
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  @providers = {:google_oauth2 => "Google", :facebook => "Facebook"}

  def self.provides_callback_for(provider, name)
    class_eval %Q{
      def #{provider}
        auth = request.env["omniauth.auth"]
        identity = User.find_for_oath(auth)

        if identity
          sign_in_and_redirect(identity, :event => :authentication)
          set_flash_message(:notice, :success, :kind => "#{name}") if is_navigational_format?
        else
          token = session[:invitation_token]
          if token && user = User.find_by_invitation_token(token, true)
            session[:invitation_token] = nil
            user.accept_invitation!
            user.update_attributes(auth.slice(:provider, :uid))
            sign_in_and_redirect(user, :event => :authentication)
            set_flash_message(:notice, :success, :kind => "#{name}") if is_navigational_format?
          else
            redirect_to new_user_session_path
          end
        end
      end
    }
  end

  @providers.each do |provider, name|
    provides_callback_for provider, name
  end
end

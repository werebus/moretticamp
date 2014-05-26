class Users::InvitationController < Devise::InvitationsController
  def edit
    if params[:invitation_token] && self.resource == resource_class.to_adaptor.find_first( invitation_token: params[:invitation_token] )
      session[:invitation_token] = params[:invitation_token]
      render :edit
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to_after_signout_path_for(resource_name)
    end
  end

  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      session[:invitation_token] = nil
      set_flash_message(:notice, :updated)
      sign_in(resource_name, resource)
      respond_with resource, location: after_accept_path_for(resource)
    else
      respond_with_navigation(resource){ render :edit }
    end
  end
end

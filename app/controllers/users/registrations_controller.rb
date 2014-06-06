class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    @oauth = Users::OmniauthCallbacksController.available_providers[ resource.provider.try(:to_sym) ]
    super
  end

  protected

  def update_resource( resource, params )
    if needs_password?( resource, params )
      resource.update_with_password( params )
    else
      params.delete( :current_password )
      params.delete( :password )
      params.delete( :password_confirmation )
      resource.update_without_password( params )
    end
  end

  private
 
  def needs_password?( resource, params )
    params[:password].present? || resource.encrypted_password.present?
  end
end

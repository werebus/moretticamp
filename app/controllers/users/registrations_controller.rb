class Users::RegistrationsController < Devise::RegistrationsController

  def edit
    @oauth = OAUTH_PROVIDERS.select{|oap| oap.label == resource.provider.try(:to_sym)}.first.name
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

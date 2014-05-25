class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_except_login

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).concat [:first_name, :last_name, :calendar_access_token]
  end

  def layout_except_login
    if user_signed_in?
      "application"
    else
      "login"
    end
  end
end

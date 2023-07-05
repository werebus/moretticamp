# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_except_login

  protected

  def require_admin
    redirect_to events_path unless current_user.admin
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :invite, keys: %i[first_name last_name]
    devise_parameter_sanitizer.permit :account_update, keys: %i[first_name last_name email_updates
                                                                calendar_access_token]
  end

  def layout_except_login
    user_signed_in? ? 'application' : 'login'
  end
end

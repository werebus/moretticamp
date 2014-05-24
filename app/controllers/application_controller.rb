class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout :layout_except_login

  protected

  def layout_except_login
    if user_signed_in?
      "application"
    else
      "login"
    end
  end
end

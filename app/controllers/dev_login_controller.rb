# frozen_string_literal: true

# :nocov:
class DevLoginController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.find_by(id: params[:id])
    if user.present?
      sign_in(:user, user)
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end
end
# :nocov:

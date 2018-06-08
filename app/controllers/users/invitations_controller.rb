# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    def edit
      resource.invitation_token = params[:invitation_token]
      session[:invitation_token] = params[:invitation_token]
      render :edit
    end

    def update
      session[:invitation_token] = nil
      super
    end
  end
end

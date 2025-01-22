# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    prepend_before_action -> { request.format = 'html' }, only: :edit

    def edit
      session[:invitation_token] = params[:invitation_token]
      resource.email_updates = true
      super
    end

    def update
      session[:invitation_token] = nil
      super
    end
  end
end

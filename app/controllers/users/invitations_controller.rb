# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    prepend_before_action -> { request.format = 'html' }, only: :edit
    before_action :set_users, only: %i[to_grant grant]

    def edit
      session[:invitation_token] = params[:invitation_token]
      resource.email_updates = true
      super
    end

    def update
      session[:invitation_token] = nil
      super
    end

    def to_grant
      @invitation_granter = InvitationGranter.new(user_ids: @users.map(&:id))
    end

    def grant
      invitation_params = params.require(:invitation_granter).permit(:quantity, user_ids: [])
      @invitation_granter = InvitationGranter.new(invitation_params)
      @invitation_granter.grant!
      redirect_to root_path, notice: t('.success', **@invitation_granter.status)
    rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError
      flash.now[:alert] = @invitation_granter.errors.full_messages.to_sentence
      render :to_grant, status: :unprocessable_entity
    end

    private

    def set_users
      @users = User.active.select { |user| user.lifetime_invitation_count.zero? }
    end
  end
end

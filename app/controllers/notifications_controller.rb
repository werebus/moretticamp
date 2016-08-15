class NotificationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :require_admin

  def new; end

  def create
    params.require :subject
    params.require :body
    params.permit :override

    users = params[:override].present? ? User.all : User.where(email_updates: true)
    users.each do |user|
      NotificationMailer.notification_email(user, params[:subject], params[:body]).deliver
    end

    flash.notice = pluralize(users.count, 'notification') + " delivered."
    redirect_to '/'
  end
end

class NotificationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :require_admin

  def new; end

  def create
    params.require :subject
    params.require :body
    params.permit :override

    users = params[:override].present? ? User.all : User.where(email_updates: true)
    body = Kramdown::Document.new(params[:body]).to_html

    users.each do |user|
      NotificationMailer.notification_email(user, params[:subject], body).deliver
    end

    flash.notice = pluralize(users.count, 'notification') + " delivered."
    redirect_to '/'
  end
end

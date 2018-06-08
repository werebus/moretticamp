# frozen_string_literal: true

class NotificationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :require_admin

  def new; end

  def create
    params.require :subject
    params.require :body
    params.permit :override

    body = Kramdown::Document.new(params[:body]).to_html

    users = User.to_notify params[:override].present?
    users.each do |user|
      NotificationMailer.notification_email(user, params[:subject], body).deliver
    end

    flash.notice = pluralize(users.count, 'notification') + ' delivered.'
    redirect_to '/'
  end
end

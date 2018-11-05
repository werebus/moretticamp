# frozen_string_literal: true

class NotificationsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :require_admin

  def create
    params.require %i[subject body]
    params.permit :override

    number_sent = NotificationService.send(params)
    flash.notice = pluralize(number_sent, 'notification') + ' delivered.'
    redirect_to '/'
  end
end

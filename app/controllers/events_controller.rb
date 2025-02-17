# frozen_string_literal: true

class EventsController < ApplicationController
  include EventsIndex

  before_action :set_event, only: %i[show edit update destroy]
  before_action :require_ownership, only: %i[edit update destroy]

  skip_before_action :authenticate_user!, only: :feed

  def show
    @owner = current_user.admin || @event.user == current_user
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    @event.user = current_user unless current_user.admin

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: t('.success') }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: t('.success') }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def feed
    if params[:format] == 'ics' && valid_token?(params[:token])
      render plain: Event.ical.to_ical, content_type: 'text/calendar'
    else
      render file: 'public/401.html', layout: false, status: :unauthorized
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def require_ownership
    redirect_to @event unless current_user.admin || @event.user == current_user
  end

  def event_params
    permitted = %i[id start_date end_date title description user_id]
    params.require(:event).permit(permitted)
  end

  def valid_token?(token)
    user_signed_in? || User.where(calendar_access_token: token).present?
  end
end

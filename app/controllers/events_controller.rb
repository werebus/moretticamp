# frozen_string_literal: true

class EventsController < ApplicationController
  include EventsIndex

  before_action :set_event, only: %i[show edit update destroy]
  before_action :require_ownership, only: %i[edit update destroy]

  skip_before_action :authenticate_user!, only: :feed

  def index
    @season = Season.current_or_next
    @events = EventsService.find(params)

    respond_to do |format|
      format.html { html_index }
      format.json
      format.ics { ics_index }
      format.pdf { pdf_index }
    end
  end

  def show
    @owner = current_user.admin || @event.user == current_user
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user unless current_user.admin

    respond_to do |format|
      if @event.save
        format.html do
          redirect_to @event, notice: 'Event was successfully created.'
        end
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json do
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html do
          redirect_to @event, notice: 'Event was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json do
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html do
        redirect_to events_url, notice: 'Event was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def feed
    if params[:format] == 'ics' && valid_token?(params[:token])
      render plain: Event.ical.to_ical, content_type: 'text/calendar'
    else
      render file: 'public/401.html', layout: false, status: 401
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

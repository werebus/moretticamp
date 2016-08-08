class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_ownership, only: [:edit, :update, :destroy]

  skip_before_action :authenticate_user!, only: :feed

  # GET /events
  # GET /events.json
  def index
    @season = Season.current_or_next

    return unless @season
    @date = [@season.start_date, Date.today].max
    @include_today = (@season.date_range.include? Date.today)

    if params[:start] && params[:end]
      start_time = Date.parse(params[:start])
      end_time = Date.parse(params[:end])
      @events = Event.between(start_time, end_time)
    else
      @events = Event.all
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @owner = current_user.admin || @event.user == current_user
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user unless current_user.admin

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def feed
    if params[:format] == 'ics' && (user_signed_in? || User.where(calendar_access_token: params[:token]).any?)
      @events = Event.all
      render action: 'index'
    else
      render file: 'public/401.html', layout: false, status: 401
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def require_ownership
    redirect_to @event unless current_user.admin || @event.user == current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:id, :start_date, :end_date, :title, :description, :user_id)
  end
end

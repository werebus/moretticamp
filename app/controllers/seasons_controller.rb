# frozen_string_literal: true

class SeasonsController < ApplicationController
  before_action :set_season, only: %i[show edit update destroy]
  before_action :require_admin, except: :index

  def index
    @seasons = Season.order(start_date: :desc)
    @current_season = Season.current_or_next
  end

  def show; end

  def new
    @season = Season.new
  end

  def edit; end

  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to seasons_path, notice: t('.success') }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { render :new }
        format.json do
          render json: @season.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to seasons_path, notice: t('.success') }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit }
        format.json do
          render json: @season.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to seasons_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_season
    @season = Season.find(params[:id])
  end

  def season_params
    params.require(:season).permit(:start_date, :end_date)
  end
end

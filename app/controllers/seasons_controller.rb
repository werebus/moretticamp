# frozen_string_literal: true

class SeasonsController < ApplicationController
  before_action :set_season, only: %i[show edit update destroy]
  before_action :require_admin, except: :index

  def index
    respond_to do |format|
      format.html do
        @seasons = Season.order(start_date: :desc)
      end
      format.json do
        render 'show', locals: { season: Season.current_or_next }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        render locals: { season: @season }
      end
    end
  end

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
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to seasons_path, notice: t('.success') }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
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
    params.expect(season: %i[start_date end_date available])
  end
end

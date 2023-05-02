class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :destroy]
  def index
    render json: Location.all.order(created_at: :desc).page(1).per(5)
  end

  def show
    if @location.blank?
      render json: { error: @location.errors.full_messages }, status: :not_found
    else
      render json: { location: @location }, status: :ok
    end
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      LocationServiceJob.perform_later(location.id)
      render json: { location: @location, message: "Location is created, request is queued" }, status: :created
    else
      render json: { error: @location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @location.blank?
      render json: { error: 'Location not found' }, status: :not_found
    else
      @location.destroy
      head :no_content
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  attr_reader :location

  def location_params
    params.permit(:ip)
  end
end

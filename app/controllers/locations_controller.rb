class LocationsController < ApplicationController
  def index
    render json: Location.all.order(created_at: :desc).page(1).per(5)
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

  private

  attr_reader :location

  def location_params
    params.permit(:ip)
  end
end

class LocationsController < ApplicationController
  def index
    Location.all
  end

  def create
    location_hash = IpstackService.new(location_params[:ip]).call
    @location = Location.new(location_hash)

    if @location.save
      render json: { location: @location, message: 'location saved' }, status: :ok
    else
      render json: { message: @location.errors.full_messages }, status: :bad_request
    end
  end

  private

  def location_params
    params.require(:location).permit(:ip)
  end
end

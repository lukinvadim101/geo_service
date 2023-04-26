class LocationsController < ApplicationController
  def index
    render json: Location.all.order(created_at: :desc).page(1)
  end

  def create
    # to make Location.find(location_params[:ip])
    location_service_response = IpstackService.new(location_params[:ip]).call
    binding.pry
    @location = Location.new(location_service_response[:payload])

    if location.save
      render json: { location: }, status: :ok
    else
      render json: { errors: location.errors.full_messages }, status: :bad_request
    end
  end

  private

  attr_reader :location

  def location_params
    params.permit(:ip)
  end
end

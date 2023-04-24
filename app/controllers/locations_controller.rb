class LocationsController < ApplicationController
  def index
    Location.all
  end

  def create
    if location_params[:ip].blank?
      render json: { error: 'Required parameter is empty' }, status: :unprocessable_entity
      return
    end

    location_service_response = IpstackService.new(location_params[:ip]).call

    render json: { error: 'Required parameter is empty' }, status: :unprocessable_entity if location_service_response["errors"].present?

    @location = Location.new(location_service_response[:payload])

    if @location.save
      render json: { location: @location, message: 'location saved' }, status: :ok
    else
      render json: { location: @location, message: 'location NOT saved' }, status: :bad_request
    end
  end

  private

  def location_params
    params.require(:location).permit(:ip)
  end
end

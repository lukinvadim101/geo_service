class LocationsController < ApplicationController
  def index
    render json: Location.all.order(created_at: :desc).page(1).per(5)
  end

  def create
    location_service_response = IpstackService.new(location_params[:ip]).call

    if location_service_response[:error].present?
      render json: location_service_response, status: :unprocessable_entity
    else
      @location = Location.find_or_create_by(location_service_response[:payload])

      if @location.save
        render json: { location: @location }, status: :ok
      else
        render json: { errors: @location.errors.full_messages }, status: :bad_request
      end
    end
  end

  private

  attr_reader :location

  def location_params
    params.permit(:ip)
  end
end

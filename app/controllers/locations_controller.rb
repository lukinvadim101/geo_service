class LocationsController < ApplicationController
  def index
    Location.all
  end

  def create
    location = Location.new(location_params)
  end

  private

  def location_params
    params.require(:location).permit(:ip)
  end
end

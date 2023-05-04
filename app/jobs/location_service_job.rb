class LocationServiceJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find(location_id)
    location_service_response = GeoService.new.call(location.ip)
    location.update(location_service_response[:payload])
  end
end

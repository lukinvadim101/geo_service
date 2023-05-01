class LocationServiceJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find(location_id)
    location_service_response = IpstackService.new(location.ip).call
    location.update(location_service_response[:payload])
  end
end

class LocationServiceJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    location = Location.find(location_id)
    services = [IpstackService.new]
    response = LocationServiceChain.new(services).call(location.ip)

    location.update(response[:payload])
  end
end

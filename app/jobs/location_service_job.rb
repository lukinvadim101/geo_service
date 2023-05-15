class LocationServiceJob < ApplicationJob
  queue_as :default
  retry_on Timeout::Error, Faraday::TimeoutError, Faraday::ConnectionFailed, wait: :exponentially_longer
  def perform(location_id)
    location = Location.find(location_id)
    services = [IpstackService.new]
    response = LocationServiceChain.new(services).call(location.ip)

    if response.present?
      location.update(response[:payload])
    else
      logger.error do
        "Cant get location data in serviceJob for: #{ip_address}"
      end
    end
  end
end

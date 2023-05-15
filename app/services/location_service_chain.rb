class LocationServiceChain
  def initialize(services)
    @services = services
  end

  def call(ip_address)
    @services.each do |service|
      location_data = service.call(ip_address)
      return location_data unless location_data.nil?
    end
    logger.error { "Cant use any of locations services for search param: #{ip_address}" }
    nil
  end
end

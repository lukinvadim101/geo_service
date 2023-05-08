class LocationServiceChain
  def initialize(services)
    @services = services
  end

  def call(ip_address)
    @services.each do |service|
      location_data = service.call(ip_address)
      return location_data if location_data.present?
    end

    nil
  end
end

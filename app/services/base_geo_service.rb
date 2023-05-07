class BaseGeoService
  def initialize(service = 'ipstack')
    service_class = Object.const_get("#{service.capitalize}Service")
    @service = service_class.new
  end

  def call(search_param)
    raise NotImplementedError, 'Subclasses must implement #call method'
  end
end

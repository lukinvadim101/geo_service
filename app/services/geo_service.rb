class GeoService
  def self.call(search_param, service = 'ipstack')
    send("#{service}_call", search_param)
  end
end

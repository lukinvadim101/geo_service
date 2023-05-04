class GeoService
  def call(search_param, service = 'ipstack')
    send("#{service}_call", search_param)
  end
end

class IpstackService < BaseLocationService
  def call(search_param)
    return { error: "Invalid search parameter" } if search_param.blank?

    access_key = ENV.fetch('IPSTACK_API_KEY', '')
    service_url = ENV.fetch('IPSTACK_URL', '')
    connection = Faraday.new(service_url) do |conn|
      conn.response :json
      conn.response :raise_error
    end

    response = connection.get(search_param, { access_key:, output: :json })

    { payload: LocationDecorator.new(response.body).handle_response }
  rescue Faraday::Error => e
    { error: "Error fetching data: #{e.message}" }
  end
end

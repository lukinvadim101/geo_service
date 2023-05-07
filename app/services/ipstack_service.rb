class IpstackService < BaseGeoService
  def initialize
    super
    create_connection
    @access_key = ENV.fetch('IPSTACK_API_KEY', '')
  end

  def call(search_param)
    return { error: "Invalid search parameter" } if search_param.blank?

    response = @connection.get(search_param, { access_key: @access_key, output: :json })

    { payload: LocationDecorator.new(response.body).handle_response }
  rescue Faraday::Error => e
    { error: "Error fetching data: #{e.message}" }
  end

  private

  def create_connection
    service_url = ENV.fetch('IPSTACK_URL', '')

    Faraday.new(service_url) do |conn|
      conn.response :json
      conn.response :raise_error
    end
  end
end

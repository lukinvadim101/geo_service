class IpstackService
  def initialize(search_param)
    @search_param = search_param
    @access_key = ENV.fetch('IPSTACK_API_KEY', '')
    @connection ||= Faraday.new('http://api.ipstack.com/') do |conn|
      conn.response :json
      conn.response :raise_error
    end
  end

  def call
    response = @connection.get(search_param, { access_key: @access_key, output: :json })
    location_hash = LocationDecorator.new(response.body).handle_response
    { payload: location_hash }
  rescue Faraday::Error => e
    # to add logger
    { error: "Error fetching data: #{e.message}" }
  end

  private

  attr_reader :search_param
end

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
    return { error: "Invalid search parameter" } if search_param.blank?

    response = @connection.get(search_param, { access_key: @access_key, output: :json })
    { payload: LocationDecorator.new(response.body).handle_response }
  rescue Faraday::Error => e
    { error: "Error fetching data: #{e.message}" }
  end

  private

  attr_reader :search_param
end

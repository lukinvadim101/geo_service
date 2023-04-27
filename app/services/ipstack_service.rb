class IpstackService
  def initialize(ip)
    @ip_param = ip
    @access_key = ENV.fetch('IPSTACK_API_KEY', '')
    @connection ||= Faraday.new('http://api.ipstack.com/') do |conn|
      conn.response :json
      conn.response :raise_error
    end
  end

  def call
    if valid_ip_address?
      response = @connection.get(ip_param, { access_key: @access_key, output: :json })
      handle_response(response)
    else
      { error: 'Invalid IP' }
    end
  rescue Faraday::Error => e
    { error: "Error fetching data: #{e.message}" }
  end

  private

  attr_reader :ip_param

  def valid_ip_address?
    ipv4_regex = /^(\d{1,3}\.){3}\d{1,3}$/
    ipv6_regex = /^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$/

    !!(ip_param =~ ipv4_regex || ip_param =~ ipv6_regex)
  end

  def handle_response(response)
    if response.success?
      { payload: LocationDecorator.new(response.body).handle_response }
    else
      { error: "Error fetching data: #{response.body}", status: response.status }
    end
  end
end

class IpstackService
  def initialize(user_param)
    @user_param = user_param
    @access_key = ENV.fetch('IPSTACK_API_KEY', '')
    @connection ||= Faraday.new('http://api.ipstack.com/') do |conn|
      conn.response :json
      conn.response :raise_error
    end
  end

  def call
    if valid_ip_address?(user_param)
      @response = @connection.get(user_param, { access_key: @access_key })
      if @response.success?
        success_response
      else
        error_response
      end
    else
      { error: 'Invalid IP', status: :unprocessable_entity }
    end
  rescue Faraday::Error => e
    { error: "Error fetching data: #{e.message}" }
  end

  private

  attr_reader :user_param

  def valid_ip_address?(ip_address)
    ipv4_regex = /^(\d{1,3}\.){3}\d{1,3}$/
    ipv6_regex = /^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$/
    binding.pry
    # check if the string matches either IPv4 or IPv6 pattern
    !!(ip_address =~ ipv4_regex || ip_address =~ ipv6_regex)
  end

  def success_response
    { error: nil,
      payload: LocationDecorator.new(@response.body).handle_response }
  end

  def error_response
    { error: "Error fetching data: #{@response.body}",
      status: @response.status }
  end
end

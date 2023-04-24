class IpstackService
  def initialize(param)
    @param = param
    @access_key = ENV.fetch('IPSTACK_API_KEY', '')
    @connection ||= Faraday.new('http://api.ipstack.com/') do |conn|
      conn.response :json
      conn.response :raise_error
    end
  end

  def call
    @response = @connection.get(@param, { access_key: @access_key })

    if @response.success?
      success_response
    else
      error_response
    end
  rescue Faraday::Error => e
    render json: { error: "Error fetching data: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def success_response
    {
      status: @response.status,
      payload: LocationDecorator.new(@response.body).handle_response
    }
  end

  def error_response
    {
      status: @response.status,
      error: "Error fetching data: #{@response.body}"
    }
  end
end

class IpstackService
  def initialize(param)
    @param = param
  end

  def call
    connection ||= Faraday.new('http://api.ipstack.com/') do |conn|
      conn.response :json
      conn.response :raise_error
    end

    begin
      response = connection.get(@param, {
                                  access_key: ENV.fetch('IPSTACK_API_KEY', nil)
                                })

      LocationDecorator.new(
        response.body.with_indifferent_access
      ).call
    end
  end
end

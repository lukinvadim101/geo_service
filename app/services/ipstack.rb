class Ipstack
  def initialize(param)
    @param = param
  end

  def call
    conn ||= Faraday.new(
      url: 'http://api.ipstack.com/',
      headers: { 'Content-Type' => 'application/json' }
    )

    response = conn.get(@param, {
                          access_key: ENV.fetch('IPSTACK_API_KEY', nil)
                        })
    # to do serializer
    JSON.parse(response.body)
  end
end

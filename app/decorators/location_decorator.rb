class LocationDecorator
  def initialize(location)
    @location = location
  end

  def call
    {
      ip: @location[:ip],
      name: concat_name,
      latitude: @location[:latitude],
      longitude: @location[:longitude]
    }.with_indifferent_access
  end

  private

  def concat_name
    "#{@location[:city]}, #{@location[:zip]}"
  end
end

FactoryBot.define do
  factory :location, class: :Location do
    ip { "11.11.11.11" }
  end

  factory :location_hash, class: :Location do
    { payload: {
      name: 'Mountain View, 94043',
      latitude: 37.4192,
      longitude: -122.0574
    } }
  end
end

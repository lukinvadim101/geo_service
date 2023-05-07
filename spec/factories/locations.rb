FactoryBot.define do
  factory :location, class: :Location do
    ip { Faker::Internet.unique.ip_v6_address }
  end

  factory :location_hash, class: :Location do
    { payload: {
      name: 'Mountain View, 94043',
      latitude: 37.4192,
      longitude: -122.0574
    } }
  end
end

FactoryBot.define do
  factory :location, class: :Location do
    ip { Faker::Internet.unique.ip_v4_address }
  end
end

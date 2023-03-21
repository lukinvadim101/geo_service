FactoryBot.define do
  factory :location do
    ip { "11.11.11.11" }
    name { "Location Name" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end

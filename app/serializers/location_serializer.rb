class LocationSerializer < ActiveModel::Serializer
  attributes :ip, :name, :latitude, :longitude
end

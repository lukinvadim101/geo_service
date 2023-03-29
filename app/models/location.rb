class Location < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
end

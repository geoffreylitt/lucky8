class School < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :types
  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode
end

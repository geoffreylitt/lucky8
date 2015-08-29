class School < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :types
  has_and_belongs_to_many :tags
  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def total_size
    school_size_9_grade +
    school_size_10_grade +
    school_size_11_grade +
    school_size_12_grade
  end
end

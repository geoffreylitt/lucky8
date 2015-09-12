class School < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :types
  has_and_belongs_to_many :tags
  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def total_size
    (school_size_9_grade || 0) +
    (school_size_10_grade || 0) +
    (school_size_11_grade || 0) +
    (school_size_12_grade || 0)
  end

  # the image url for this school, with a fallback
  def image_url
    read_attribute(:image_url) || "https://upload.wikimedia.org/wikipedia/commons/d/d0/Lmspic.png"
  end

  # A shorter about description.
  # Cuts off anything after the first newline, then truncates what's left.
  def short_about
    about.split("<br>").first.truncate(180)
  end
end

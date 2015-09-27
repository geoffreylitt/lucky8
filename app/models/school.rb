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

  # An arbitrary but consistent color from the Citizens brand to
  # use to represent this school
  def color
    colors = %w(green blue gold red)
    colors[(name.length) % 4]
  end

  # Whether there is any population information for this school
  def population_info_present?
    school_population_hispanic || 
    school_population_african_american ||
    school_population_white ||
    school_population_asian ||
    school_population_multi_race_non_hispanic
  end

  # Whether there is any 'other key indicators' information for the school
  def other_key_indicator_info_present?
    attendance_rate ||
    avg_class_size ||
    ell_percentage
  end

  def post_grad_intentions_info_present?
    post_grad_four_yr_college ||
    post_grad_two_yr_college ||
    post_grad_unknown
  end
end

class Event < ApplicationRecord
  validates :name, :location, presence: true
  validates :description, length: { minimum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :image_file_name, allow_blank: true, format: {
    with:    /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }
  

  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  scope :past, -> { where('starts_at < ?', Time.now).order('starts_at') }
  scope :upcoming, -> { where('starts_at >= ?', Time.now).order('starts_at') }
  # Ex:- scope :active, -> {where(:active => true)}
  # Ex:- scope :active, -> {where(:active => true)}

  def free?
    price.blank? || price.zero?    
  end

  # def self.past
  #   where('starts_at < ?', Time.now).order('starts_at')
  # end

  # def self.upcoming
  #   where('starts_at >= ?', Time.now).order('starts_at')
  # end

  def spots_left
    capacity - registrations.size
  end

  def sold_out?
    spots_left.zero?    
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  
end

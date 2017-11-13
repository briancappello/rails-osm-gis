class Waypoint < ApplicationRecord
  belongs_to :ride
  has_many :pictures, dependent: :destroy
  validates :lat, presence: true
  validates :lon, presence: true
  validate :valid_lat
  validate :valid_lon

  def valid_lat
    return false if lat.nil?
    if self.lat < -90.0
      errors.add(:lat, 'must be greater than or equal to -90°')
    elsif self.lat > 90.0
      errors.add(:lat, 'must be less than or equal to 90°')
    end
  end

  def valid_lon
    return false if lon.nil?
    if self.lon < -180.0
      errors.add(:lat, 'must be greater than or equal to -180°')
    elsif self.lon > 180.0
      errors.add(:lat, 'must be less than or equal to 180°')
    end
  end

end

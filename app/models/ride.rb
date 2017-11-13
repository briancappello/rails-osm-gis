class Ride < ApplicationRecord
  belongs_to :user
  belongs_to :trail
  has_many :waypoints, dependent: :destroy
  mount_uploader :gpx_file, ::GpxUploader
  validates :start, presence: true
  validates :end, presence: true
  validates :gpx_file, presence: true
  validate :valid_duration

  def valid_duration
    return false if self.start.nil? or self.end.nil?
    if self.end <= self.start
      errors.add(:start, 'must come before end')
    end
  end

  def duration
    return false if self.start.nil? or self.end.nil?
    self.end - self.start
  end

end

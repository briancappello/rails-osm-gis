class Ride < ApplicationRecord
  attr_accessor :_gpx
  belongs_to :user
  belongs_to :trail
  has_many :waypoints, dependent: :destroy
  mount_uploader :gpx_file, ::GpxUploader
  before_validation :set_start_end_from_gpx
  validates :start, presence: true
  validates :end, presence: true
  validates :gpx_file, presence: true
  validate :valid_duration

  def valid_duration
    return if self.start.nil? || self.end.nil?
    if self.end <= self.start
      errors.add(:start, 'must come before end')
    end
  end

  def duration
    set_start_end_from_gpx
    return if self.start.nil? || self.end.nil?
    self.end - self.start
  end

  def gpx
    if gpx_file.file
      self._gpx ||= GPX::GPXFile.new(gpx_file: gpx_file.file.file)
    end
  end

  private
    def set_start_end_from_gpx
      return if gpx.nil?
      if self.start.nil?
        self.start = gpx.tracks[0].segments[0].points[0].time
      end
      if self.end.nil?
        self.end = gpx.tracks[-1].segments[-1].points[-1].time
      end
    end

end

class Ride < ApplicationRecord
  attr_accessor :_gpx, :_start, :_end, :_center
  before_save :update_gpx_metadata
  before_validation :update_gpx_metadata
  belongs_to :user
  belongs_to :trail
  has_many :waypoints, dependent: :destroy
  mount_uploader :gpx_file, ::GpxUploader
  validates :gpx_file, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  def gpx
    return if gpx_file.file.nil?
    self._gpx ||= GPX::GPXFile.new(gpx_file: gpx_file.file.file)
  end

  def bounds_center
    return if gpx.nil?
    self._center ||= [
      midpoint(gpx.bounds.min_lat, gpx.bounds.max_lat, 90),
      midpoint(gpx.bounds.min_lon, gpx.bounds.max_lon, 180)
    ]
  end

  def start
    return if gpx.nil?
    self._start ||= gpx.tracks[0].segments[0].points[0]
  end

  def end
    return if gpx.nil?
    self._end ||= gpx.tracks[-1].segments[-1].points[-1]
  end

  private

    def midpoint(a, b, max)
      sum = a + b
      # handle the edgecase when crossing over from eg -179 to 179.5
      if sum.abs != sum && sum.abs < max
        max + (sum / 2)
      else
        sum / 2
      end
    end

    def update_gpx_metadata
      return if gpx.nil?
      self.start_time = start.time
      self.end_time = self.end.time
      self.duration = gpx.duration
      self.moving_duration = gpx.moving_duration
      self.distance = gpx.distance(units: 'miles')
      self.avg_speed = gpx.average_speed(units: 'miles')
    end

end

require 'test_helper'

class RideTest < ActiveSupport::TestCase

  def setup
    start = 50.minutes.ago
    @ride = Ride.new(user: users(:user),
                     trail: trails(:pond_loop),
                     start: start,
                     end: start + 45.minutes,
                     gpx_file: fixture_file('browns-camp-loop.gpx'))
  end

  test 'should be valid' do
    assert @ride.valid?
  end

  test 'user is required' do
    @ride.user = nil
    assert_not @ride.valid?
  end

  test 'trail is required' do
    @ride.trail = nil
    assert_not @ride.valid?
  end

  test 'start is required' do
    @ride.start = nil
    assert_not @ride.valid?
  end

  test 'end is required' do
    @ride.end = nil
    assert_not @ride.valid?
  end

  test 'ride start must come before the end' do
    @ride.start = 5.minutes.ago
    @ride.end = 10.minutes.ago
    assert_not @ride.valid?
    @ride.end = @ride.start
    assert_not @ride.valid?
  end

  test 'ride duration' do
    assert_equal 45.minutes, @ride.duration
  end

  test 'gpx file required' do
    @ride.gpx_file = nil
    assert_not @ride.valid?
  end

  test 'deleting a ride should delete its waypoints' do
    @ride.save
    @ride.waypoints.create!(lat: 45, lon: -123)
    assert_difference 'Waypoint.count', -1 do
      @ride.destroy
    end
  end

end

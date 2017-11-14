require 'test_helper'

class RideTest < ActiveSupport::TestCase

  def setup
    @ride = Ride.new(user: users(:user),
                     trail: trails(:pond_loop),
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

  test 'start is set from gpx file' do
    assert @ride.valid?
    assert @ride.start_time
  end

  test 'end is set from gpx file' do
    assert @ride.valid?
    assert @ride.end_time
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

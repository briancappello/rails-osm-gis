require 'test_helper'

class WaypointTest < ActiveSupport::TestCase

  def setup
    @waypoint = Waypoint.new(lat: 45.622038,
                             lon: -123.37551,
                             ride: rides(:ride),
    )
  end

  test 'should be valid' do
    assert @waypoint.valid?
  end

  test 'latitude required' do
    @waypoint.lat = nil
    assert_not @waypoint.valid?
  end

  test 'valid latitude' do
    @waypoint.lat = -90.1
    assert_not @waypoint.valid?, '-90.1 should not be valid'

    @waypoint.lat = -90
    assert @waypoint.valid?, '-90 should be valid'

    @waypoint.lat = 0
    assert @waypoint.valid?, '0 should be valid'

    @waypoint.lat = 90
    assert @waypoint.valid?, '90 should be valid'

    @waypoint.lat = 90.1
    assert_not @waypoint.valid?, '90.1 should not be valid'
  end

  test 'longitude required' do
    @waypoint.lon = nil
    assert_not @waypoint.valid?
  end

  test 'valid longitude' do
    @waypoint.lon = -180.1
    assert_not @waypoint.valid?, '-180.1 should not be valid'

    @waypoint.lon = -180
    assert @waypoint.valid?, '-180 should be valid'

    @waypoint.lon = 0
    assert @waypoint.valid?, '0 should be valid'

    @waypoint.lon = 180
    assert @waypoint.valid?, '180 should be valid'

    @waypoint.lon = 180.1
    assert_not @waypoint.valid?, '180.1 should not be valid'
  end

  test 'accept degree string for lat' do
    @waypoint.lat = '90°'
    assert @waypoint.valid?
    assert_equal 90, @waypoint.lat
  end

  test 'accept degree string for lon' do
    @waypoint.lon = '90°'
    assert @waypoint.valid?
    assert_equal 90, @waypoint.lon
  end

  test 'should delete pictures when waypoint is deleted' do
    @waypoint.save
    @waypoint.pictures.create!(title: 'a pic', file: fixture_file('bike.png'))
    assert_difference 'Picture.count', -1 do
      @waypoint.destroy
    end
  end

end

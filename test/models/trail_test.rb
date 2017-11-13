require 'test_helper'

class TrailTest < ActiveSupport::TestCase

  def setup
    @trail = Trail.new(name: 'pond loop', location: locations(:foo_park))
  end

  test 'should be valid' do
    assert @trail.valid?
  end

  test 'name is required' do
    @trail.name = ''
    assert_not @trail.valid?
  end

  test 'location is required' do
    @trail.location = nil
    assert_not @trail.valid?
  end

  test 'name must be unique per location' do
    dupe = @trail.dup
    @trail.save
    assert_not dupe.valid?
  end

  test 'deleting a trail should delete its rides' do
    @trail.save
    @trail.rides.create!(user: users(:user),
                         gpx_file: fixture_file('browns-camp-loop.gpx'))
    assert_difference 'Ride.count', -1 do
      @trail.destroy
    end
  end

end

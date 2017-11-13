require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  def setup
    @location = Location.new(name: 'foo park')
  end

  test 'should be valid' do
    assert @location.valid?
  end

  test 'name required' do
    @location.name = ''
    assert_not @location.valid?
  end

  test 'deleting a location should delete its trails' do
    @location.save
    @location.trails.create!(name: 'pond loop')
    assert_difference 'Trail.count', -1 do
      @location.destroy
    end
  end

end

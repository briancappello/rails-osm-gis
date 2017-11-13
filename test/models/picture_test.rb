require 'test_helper'

class PictureTest < ActiveSupport::TestCase

  def setup
    @picture = Picture.new(file: fixture_file('bike.png'))
  end

  test 'should be valid' do
    assert @picture.valid?
  end

  test 'file required' do
    @picture.file = nil
    assert_not @picture.valid?
  end

end

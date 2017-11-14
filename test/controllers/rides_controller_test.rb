require 'test_helper'

class RidesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
    login_as(@user)
    @ride = Ride.create!(user: @user,
                         trail: trails(:pond_loop),
                         gpx_file: fixture_file('browns-camp-loop.gpx'))
  end

  test 'should get show' do
    get ride_url(@ride)
    assert_response :success
  end

end

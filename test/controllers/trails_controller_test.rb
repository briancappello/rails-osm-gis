require 'test_helper'

class TrailsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @trail = trails(:pond_loop)
  end

  test 'should get show' do
    get location_trail_path(location_id: @trail.location.id, id: @trail.id)
    assert_response :success
  end

end

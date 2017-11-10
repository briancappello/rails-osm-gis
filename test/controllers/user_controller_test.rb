require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get sign_up_path
    assert_response :success
    assert_select 'title', title_helper('Sign up')
  end

end

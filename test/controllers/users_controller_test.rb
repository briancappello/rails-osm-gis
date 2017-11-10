require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(name: 'test', email: 'b@c.com',
                        password: 'password', password_confirmation: 'password')
  end

  test "should get new" do
    get sign_up_path
    assert_response :success
    assert_select 'title', title_helper('Sign up')
  end

  test 'should get show' do
    get user_path(@user.id)
    assert_response :success
    assert_select 'title', title_helper(@user.name)
  end

end

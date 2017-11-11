require 'test_helper'

class MicropostsDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
    @user2 = users(:user2)
    @micropost = microposts(:user_first)
  end

  test 'only post owner can delete it' do
    login_as(@user2)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_path

    login_as(@user)
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_path
  end

end

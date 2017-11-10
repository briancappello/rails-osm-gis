require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
    @admin = users(:admin)
  end

  test 'index should redirect if not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should get new' do
    get sign_up_path
    assert_response :success
    assert_select 'title', title_helper('Sign up')
  end

  test 'should get show' do
    get user_path(@user.id)
    assert_response :success
    assert_select 'title', title_helper(@user.name)
  end

  test 'edit requires login' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
  end

  test 'update requires login' do
    patch edit_user_path(@user), params: {
      user: {
        name: 'foo',
        email: 'bar@baz.com'
      }
    }
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
  end

  test 'edit requires correct user' do
    login_as(@user)
    get edit_user_path(@admin)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'update requires correct user' do
    login_as(@user)
    patch edit_user_path(@admin), params: {
      user: {
        name: 'foo',
        email: 'bar@baz.com'
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'change password requires login' do
    get change_password_user_path(@user)
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
  end

  test 'update password requires login' do
    patch change_password_user_path(@user), params: {
      user: {
        current_password: 'password',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.empty?
    assert_template 'sessions/new'
  end

  test 'change password requires correct user' do
    login_as(@user)
    get change_password_user_path(@admin)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'update password requires correct user' do
    login_as(@user)
    patch change_password_user_path(@admin), params: {
      user: {
        current_password: 'password',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'not possible to set user as admin via web endpoints' do
    login_as(@user)
    assert_not @user.admin?
    patch user_path(@user), params: {
      user: {
        admin: true
      }
    }
    assert_not @user.reload.admin?
  end

  test 'only admins can delete users' do
    login_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(users(:user2))
    end
    assert_redirected_to root_path
    assert_not flash.empty?

    login_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end

end

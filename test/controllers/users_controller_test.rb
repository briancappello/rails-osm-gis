require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user_one)
    @user_two = users(:user_two)
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
    login_as(@user_two)
    get edit_user_path(@user)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'update requires correct user' do
    login_as(@user_two)
    patch edit_user_path(@user), params: {
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
    login_as(@user_two)
    get change_password_user_path(@user)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test 'update password requires correct user' do
    login_as(@user_two)
    patch change_password_user_path(@user), params: {
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

end

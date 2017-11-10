require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }

    # make sure flash message is only displayed once (on the login page)
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information' do
    get login_path
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    # test logout
    get logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    get logout_path # simulate user logging out from a second window
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remember me' do
    login_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test 'login without remembering' do
    login_as(@user, remember_me: nil)
    assert_nil cookies['remember_token']
    login_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
    login_as(@user, remember_me: '')
    assert_nil cookies['remember_token']
  end

  test 'redirect after login' do
    get edit_user_path(@user)
    login_as(@user)
    assert_redirected_to edit_user_path(@user)
  end

  test 'redirect already-logged-in user to their profile page' do
    login_as(@user)
    get login_path
    assert_redirected_to @user
    assert_not flash.empty?
  end

end

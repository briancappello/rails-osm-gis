require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user_one)
  end

  test 'successful edit' do
    login_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'foobar'
    email = 'foobar@foobar.com'
    patch edit_user_path(@user), params: {
      user: {
        name: name,
        email: email,
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'edit errors' do
    login_as(@user)
    patch edit_user_path(@user), params: {
      user: {
        name: '',
        email: 'foo@invalid'
      }
    }
    assert_template 'users/edit'
    assert_select 'div.form-errors'
    assert_select 'div.field_with_errors'
  end

  test 'change password success' do
    login_as(@user)
    get change_password_user_path(@user)
    assert_template 'users/edit_password'
    current_pass = 'password'
    new_pass = 'new_password'
    patch change_password_user_path(@user), params: {
      user: {
        current_password: current_pass,
        password: new_pass,
        password_confirmation: new_pass,
      }
    }
    assert_not flash.empty?
    assert_redirected_to edit_user_path(@user)
  end

  test 'change password error on invalid current password' do
    login_as(@user)
    get change_password_user_path(@user)
    patch change_password_user_path(@user), params: {
      user: {
        current_password: 'fail',
        password: '',
        password_confirmation: ''
      }
    }
    assert_template 'users/edit_password'
    assert_equal assigns(:user).errors[:current_password], ['is not valid']
    assert_equal assigns(:user).errors[:password], ['is required']
  end

  test 'change password error on invalid new password' do
    login_as(@user)
    get change_password_user_path(@user)
    patch change_password_user_path(@user), params: {
      user: {
        current_password: 'password',
        password: 'short',
        password_confirmation: 'fail'
      }
    }
    assert_template 'users/edit_password'
    assert_equal assigns(:user).errors[:password], ['is too short (minimum is 8 characters)']
    assert_equal assigns(:user).errors[:password_confirmation], ["doesn't match Password"]
  end

  test 'change password error on new password matches existing' do
    login_as(@user)
    get change_password_user_path(@user)
    patch change_password_user_path(@user), params: {
      user: {
        current_password: 'password',
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert_template 'users/edit_password'
    assert_equal assigns(:user).errors[:password], ['must be different from your current password']
  end

end

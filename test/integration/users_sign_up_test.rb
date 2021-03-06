require 'test_helper'

class UsersSignUpTest < ActionDispatch::IntegrationTest

  test 'should generate form errors' do
    get sign_up_path
    assert_no_difference 'User.count' do
      post sign_up_path, params: {
        user: {
          name: '',
          email: 'a@invalid',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.form-errors'
    assert_select 'div.field_with_errors'
  end

  test 'should generate form errors with no password' do
    get sign_up_path
    assert_no_difference 'User.count' do
      post sign_up_path, params: {
        user: {
          name: 'name',
          email: 'a@valid.com',
          password: '',
          password_confirmation: ''
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.form-errors'
    assert_select 'div.field_with_errors'
  end

  test 'valid submission should persist a new user and log them in' do
    get sign_up_path
    assert_difference 'User.count', 1 do
      post sign_up_path, params: {
        user: {
          name: 'name',
          email: 'valid@a.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

end

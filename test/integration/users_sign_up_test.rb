require 'test_helper'

class UsersSignUpTest < ActionDispatch::IntegrationTest
  test 'should generate form errors' do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: {
          user: {
            name: '',
            email: 'a@invalid',
            password: 'foo',
            password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.form-errors'
    assert_select 'div.field_with_errors'
  end
end

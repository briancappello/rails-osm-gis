require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
    @admin = users(:admin)
  end

  test 'index pagination' do
    login_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a', text: 'delete', count: 0
      assert_select 'a[href=?][data-method="delete"]', user_path(user), false
    end
  end

  test 'admin index delete links' do
    login_as(@admin)
    get users_path
    User.paginate(page: 1).each do |user|
      unless user == @admin
        assert_select 'a[href=?][data-method="delete"]', user_path(user), text: 'delete'
      end
    end
  end

end

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
  end

  test 'should get home' do
    # test public view
    get root_url
    assert_response :success
    assert_select 'title', title_helper
    assert_select 'h1', text: 'Welcome to Sample App'

    # test user view
    login_as(@user)
    get root_url
    assert_select 'h1', text: @user.name
  end

  test 'should get help' do
    get help_url
    assert_response :success
    assert_select 'title', title_helper('Help')
  end

  test 'should get about' do
    get about_url
    assert_response :success
    assert_select 'title', title_helper('About')
  end

end

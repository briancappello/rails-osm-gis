require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_url
    assert_response :success
    assert_select 'title', title_helper
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select 'title', title_helper('Help')
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select 'title', title_helper('About')
  end

end

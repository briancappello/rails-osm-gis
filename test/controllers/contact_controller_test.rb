require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Sample App'
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end

end

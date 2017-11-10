require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select 'title', title_helper('Contact')
  end

end

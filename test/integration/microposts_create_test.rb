require 'test_helper'

class MicropostsCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user)
  end

  test 'should error on empty content' do
    login_as(@user)
    assert_no_difference 'Micropost.count' do
      post root_path, params: {
        micropost: { content: '' }
      }
    end
    assert_template 'static_pages/home'
    assert_select 'div.form-errors'
    assert_select 'div.field_with_errors'
  end

  test 'feed should still work if errors' do
    login_as(@user)
    assert_no_difference 'Micropost.count' do
      post root_path, params: {
        micropost: { content: '' }
      }
    end
    assert_template 'static_pages/home'
    assert_select '.micropost', [@user.microposts.count, Micropost.per_page].min
  end

  test 'should display new post after create' do
    content = 'lorem ipsum yo'
    login_as(@user)
    assert_difference 'Micropost.count', 1 do
      post root_path, params: {
        micropost: { content: content }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select '.micropost:first-of-type .content', text: content
  end

end

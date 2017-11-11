require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:user)
    @micropost = @user.microposts.build(content: 'lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user is required' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content is required' do
    @micropost.content = ''
    assert_not @micropost.valid?
  end

  test 'content must not exceed 140 characters' do
    maxlen = 140
    @micropost.content = 'a' * (maxlen + 1)
    assert_not @micropost.valid?
  end

  test 'sorted by default by most recent first' do
    assert_equal microposts(:admin_first), Micropost.first
  end

end

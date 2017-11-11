require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @user30 = users(:user30)
    login_as(@user)
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'should follow a user with html request' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @user30.id }
    end
  end

  test 'should follow a user with ajax request' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @user30.id }
    end
  end

  test 'should unfollow a user with html request' do
    @user.follow(@user30)
    relationship = @user.active_relationships.find_by(followed_id: @user30.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with ajax request' do
    @user.follow(@user30)
    relationship = @user.active_relationships.find_by(followed_id: @user30.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

end

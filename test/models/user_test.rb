require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'brian', email: 'b@c.com',
                     password: 'password', password_confirmation: 'password')
  end

  test 'should be valid' do
    assert @user.valid?, @user.inspect
  end

  test 'name required' do
    @user.name = ''
    assert_not @user.valid?, @user.inspect
  end

  test 'name not too long' do
    maxlen = 50
    @user.name = 'a' * (maxlen + 1)
    assert_not @user.valid?, @user.inspect
  end

  test 'email required' do
    @user.email = ''
    assert_not @user.valid?, @user.inspect
  end

  test 'email not too long' do
    maxlen = 255
    domain = '@a.com'
    @user.email = 'a' * (maxlen - domain.length + 1) + domain
    assert_not @user.valid?, @user.inspect
  end

  test 'email must be a valid address' do
    valid_addresses = %w[user@example.com
                         USER@foo.COM
                         A_US-ER@foo.bar.com
                         first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be considered valid (#{@user.inspect})"
    end

    invalid_addresses = %w[user@example,com
                           user_at_foo.org
                           user.name@example
                           foo@bar_baz.com
                           foo@bar+baz.com]
    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be considered invalid (#{@user.inspect})"
    end
  end

  test 'email must be unique' do
    dupe = @user.dup
    dupe.email = @user.email.upcase
    @user.save
    assert_not dupe.valid?, "User: #{@user.inspect}, Duplicate: #{dupe.inspect}"
  end

  test 'email downcased on save' do
    addr = 'A@EXAMPLE.com'
    @user.email = addr
    @user.save
    assert_equal addr.downcase, @user.reload.email
  end

  test 'password not blank' do
    @user.password = @user.password_confirmation = ' ' * 10
    assert_not @user.valid?, @user.inspect
  end

  test 'password minimum length' do
    minlen = 8
    @user.password = @user.password_confirmation = 'a' * (minlen - 1)
    assert_not @user.valid?, @user.inspect
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('')
  end

  test 'deleting a user cascades to the user\'s microposts' do
    @user.save
    @user.microposts.create!(content: 'lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    user29 = users(:user29)
    user30 = users(:user30)

    assert_not user29.following?(user30)
    user29.follow(user30)
    assert user29.following?(user30)
    assert user30.followers.include?(user29)
    user29.unfollow(user30)
    assert_not user29.following?(user30)
  end

  test 'feed should have the correct posts' do
    user = users(:user)
    user2 = users(:user2)
    user3 = users(:user3)

    # check for posts from self
    user.microposts.each do |own_post|
      assert user.feed.include?(own_post)
    end

    # check for posts from followed user
    user2.microposts.each do |other_post|
      assert user.feed.include?(other_post)
    end

    # check no posts from unfollowed user
    user3.microposts.each do |other_post|
      assert_not user.feed.include?(other_post)
    end

  end

end

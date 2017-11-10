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

end

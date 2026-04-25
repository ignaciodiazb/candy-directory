require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email address" do
    user = User.new(email_address: " ADMIN@EXAMPLE.COM ", password: "password")
    assert_equal "admin@example.com", user.email_address
  end

  test "requires email address" do
    user = User.new(password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires unique email address" do
    user = User.new(email_address: users(:admin).email_address, password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "requires password" do
    user = User.new(email_address: "new@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "admin defaults to false" do
    user = User.new(email_address: "new@example.com", password: "password")
    assert_not user.admin?
  end

  test "fixture admin user is an admin" do
    assert users(:admin).admin?
  end

  test "fixture regular user is not an admin" do
    assert_not users(:regular).admin?
  end
end

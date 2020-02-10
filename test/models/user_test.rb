require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'invalid without email' do
    user = User.new(
      name: 'test',
      password: '123456',
      role: 'PATREON'
    )
    assert_not user.save
  end

  test 'invalid without name' do
    user = User.new(
      email: 'test@test.com',
      password: '123456',
      role: 'PATREON'
    )
    assert_not user.save
  end

  test 'invalid role' do
    user = User.new(
      email: 'test_role@test.com',
      name: 'Role test',
      password: '123456',
      role: 'USER'
    )
    assert_not user.save
  end
end

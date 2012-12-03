
require "test_helper"

class UserTest < ActiveSupport::TestCase
  should "return roles that are gotten through groups the user belongs to" do
    board_role = FactoryGirl.create(:board_role)
    board = Group.find_by_name("Board")
    jane = User.find_by_name("Jane")

    assert_equal 1, jane.group_roles.size
    assert_equal "Board Role", jane.group_roles.first.name
  end

  should "return roles that are gotten through groups the user belongs to" do
    board_role = FactoryGirl.create(:board_role)
    board = Group.find_by_name("Board")
    jane = User.find_by_name("Jane")
    jane.roles << Role.create(:name => "Member")

    assert_equal 1, jane.roles.size
    assert_equal 1, jane.group_roles.size
    assert_equal 2, jane.all_roles.size
    assert_equal ["Board Role", "Member"], jane.all_roles.map{|role| role.name}.sort
  end
end

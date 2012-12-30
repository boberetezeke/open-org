
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    FactoryGraph.new(self).create_objects(
      :board_role => {:groups => :board},
      :jane => {:groups => :board, :roles => :member_role},
      :select_presidential_nominees_task_definition => { :role => :board_role }
    )
  end

  should "return roles that are gotten through groups the user belongs to" do
    assert_equal 1, @jane.group_roles.size
    assert_equal "Board Role", @jane.group_roles.first.name
  end

  should "return roles that are gotten through groups the user belongs to" do
    assert_equal 1, @jane.roles.size
    assert_equal 1, @jane.group_roles.size
    assert_equal 2, @jane.all_roles.size
    assert_equal ["Board Role", "Member Role"], @jane.all_roles.map{|role| role.name}.sort
  end
end

require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "define a task from a task definition" do
    fred = Person.create(:name => "fred")
    sally = Person.create(:name => "sally")
    jane = Person.create(:name => "jane")
    board = Group.create(:name => "board")
    board.people = [fred, sally, jane]
    board_role = Role.create(:name => "board")
    board.roles << board_role

    select_presidential_nominees_task_def = 
      TaskDefinition.create(
        :name => :select_presidential_nominees,
        :role => board_role
      )
    task = Task.create(
              :name => "nominate president", 
              :prototype => select_presidential_nominees_task_def)
    
    assert_equal board_role, task.role
    assert_equal board, task.owner
  end
end
 

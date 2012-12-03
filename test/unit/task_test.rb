require "test_helper"

class TaskTest < ActiveSupport::TestCase
  should "define a task from a task definition" do
    board_role = FactoryGirl.create(:board_role)
    board = board_role.groups.first

    select_presidential_nominees_task_def = 
      Task.create(
        :name => :select_presidential_nominees,
        :role => board_role,
        :is_prototype => true
      )
    task = Task.create(
              :name => "nominate president", 
              :prototype => select_presidential_nominees_task_def)
    
    assert_equal board_role, task.role
    assert_equal board, task.owner
  end
end
 

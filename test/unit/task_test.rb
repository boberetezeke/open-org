require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    FactoryGraph.new.create_objects(
      self,
      :board,
      :board_role => {:groups => :board},
      :select_presidential_nominees_task_definition => { :role => :board_role }
    )
  end

  should "define a task from a task definition" do
    task = Task.create(
              :name => "nominate president", 
              :prototype => @select_presidential_nominees_task_definition)
    
    assert_equal @board_role, task.role
    assert_equal @board, task.owner
  end
end
 

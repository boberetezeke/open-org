require 'test_helper'

class WorkFlowerTest < ActiveSupport::TestCase
  def create_task(options)
    task = Task.new
    options.each do |k,v|
      task.send("#{k}=", v)
    end
    task.save
    task
  end

  setup do
    @work_flower = WorkFlower.new
    @objects = 
    FactoryGraph.new(self).create_objects(
        :user_role      => {:users => :user1},
        :root_task_def  => {:role => :user_role},
        :mid_task_def_1 => {:role => :user_role, :dependencies => [:root_task_def]},
        :mid_task_def_2 => {:role => :user_role, :dependencies => [:root_task_def]},
        :end_task_def   => {:role => :user_role, :dependencies => [:mid_task_def_1, :mid_task_def_2]},
    )
  end

  def test_starting_a_task
    root_task = @root_task_def.create_task
    assert_equal @root_task_def, root_task.prototype
  end

  def test_finish_root_task
    root_task = @root_task_def.create_task
    @work_flower.set_task_state(root_task, @user1, :done)
    assert_equal "done", root_task.state
    assert_equal 2, root_task.depending_on.size
    assert_equal "mid_task_def_1", root_task.depending_on.sort_by{|t| t.name}[0].name
    assert_equal "in_progress", root_task.depending_on.sort_by{|t| t.name}[0].state
    assert_equal "mid_task_def_2", root_task.depending_on.sort_by{|t| t.name}[1].name
    assert_equal "in_progress", root_task.depending_on.sort_by{|t| t.name}[1].state
  end

  def test_finish_task_with_2_depends_on
    root_task = @root_task_def.create_task
    @work_flower.set_task_state(root_task, @user1, :done)
    mid_task_1 = root_task.depending_on.sort_by(&:name).first
    @work_flower.set_task_state(mid_task_1, @user1, :done)
    assert_equal 1, mid_task_1.depending_on.size
    end_task = mid_task_1.depending_on.first
    assert_equal "end_task_def", end_task.name
    assert_equal "waiting", end_task.state
  end
end

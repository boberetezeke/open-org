require "test_helper"

class MyTask < Task
  task_field :field1, :field2
end

class MyTask2 < Task
  task_field :field3, :data_type => :integer, :control_type => :slider
end

class MyTask3 < Task
  task_field :field4
  after_activation do |task|
    task.field4 = "field4 value"
  end

  after_completion do |task|
    task.field4 = "field4 final value"
  end
end

class TaskTest < ActiveSupport::TestCase
  context "testing callbacks" do
=begin
    should "call on_activate callback on task creation" do
      mytask3_prototype = MyTask3.new(:name => "my task prototype 3")
      mytask3_prototype.is_prototype = true
      mytask3_prototype.save

      my_task3 = mytask3_prototype.new_task
      my_task3.save
      assert_equal "field4 value", my_task3.field4

      my_task3.state = :done
      my_task3.save

      assert_equal "field4 final value", my_task3.field4
    end
=end
  end

  context "testing task class methods" do
    should "create task fields" do
      mytask = MyTask.new(:name => "my task")
      mytask.is_prototype = true
      mytask.save

      assert_equal 2, mytask.task_fields.size
      task_field = mytask.task_fields.shift
      assert_equal "field1", task_field.name
      assert_equal "string", task_field.data_type
      assert_equal "text_field", task_field.control_type
      task_field = mytask.task_fields.shift
      assert_equal "field2", task_field.name
      assert_equal "string", task_field.data_type
      assert_equal "text_field", task_field.control_type
    end

    should "create task fields with options" do
      mytask2 = MyTask2.new(:name => "my task")
      mytask2.is_prototype = true
      mytask2.save

      assert_equal 1, mytask2.task_fields.size
      task_field = mytask2.task_fields.shift
      assert_equal "field3", task_field.name
      #assert_equal "string", task_field.data_type
      #assert_equal "text_field", task_field.control_type
    end 
  end

  context "testing task instance methods" do
    setup do
      @factory_graph = FactoryGraph.new(self)
      @factory_graph.create_objects(
        :board_role => {:groups => :board},
        :president_role => {:users => :jane},
        :name_election_task_definition => { :role => :president_role },
        :select_nominating_committee_task_definition => { :role => :board_role }
      )
    end

    context "using name election task" do
      setup do
        @task = Task.create(
            :name => "name election",
            :prototype => @name_election_task_definition)

      end

      should "define a task from a task definition with a user role" do
        assert_equal @president_role, @task.role
        assert_equal @jane, @task.owner
      end

      context "with a name election task field" do
        setup do
          @factory_graph.create_objects(
              :election_name_task_field => { :task => :name_election_task_definition }
          )
        end

        should "return nil when asking for a task field when a task field value doesn't exist" do
          assert_equal nil, @task.election_name
        end

        should "return a value when a task field value exists" do
          @factory_graph.create_objects(
              :election_name_task_field_value => { 
                :value => "2010 Election",
                :task => @task, 
                :task_field => :election_name_task_field 
              }
          )
          
          assert_equal "2010 Election", @task.election_name
        end

        should "create a task field value object when setting a field where there is a task field object for" do
          assert_equal nil, @task.election_name
          assert_equal 0, @task.task_field_values.size
          @task.election_name = "2010 Election"
          assert_equal "2010 Election", @task.election_name
          assert_equal 0, @task.task_field_values.size
          @task.save
          @task.reload
          assert_equal 1, @task.task_field_values.size
          assert_equal "election_name", @task.task_field_values.first.task_field.name
          assert_equal "2010 Election", @task.task_field_values.first.value
          @task.election_name = "2011 Election"
          assert_equal "2011 Election", @task.election_name
          @task.save
          @task.reload
          assert_equal 1, @task.task_field_values.size
          assert_equal "2011 Election", @task.task_field_values.first.value
        end

        should "raise an exception when setting a field where a task field object doesn't exist" do
          assert_raise(RuntimeError) do
            @task.non_defined_task_field = "test"
          end
        end
      end
    end

    should "define a task from a task definition with a group role" do
      task = Task.create(
                :name => "select nominating committee", 
                :prototype => @select_nominating_committee_task_definition)
      
      assert_equal @board_role, task.role
      assert_equal @board, task.owner
    end
  end
end
 

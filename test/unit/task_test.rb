require "test_helper"

class TaskTest < ActiveSupport::TestCase
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
 

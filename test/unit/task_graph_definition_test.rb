require 'test_helper'

class TaskGraphDefinitionTest < ActiveSupport::TestCase
  setup do
    @organization = FactoryGirl.create(:pta)
  end

  should "define task_group with one empty task" do
    assert_equal 0, TaskGraphDefinition.count

    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees do
        end
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 1, TaskDefinition.count
    tgd = TaskGraphDefinition.first
    assert_equal true, tgd.current_revision
    assert_equal 1, tgd.version
    assert_equal ["select_presidential_nominees"], TaskDefinition.all.map(&:name)

    tgd2 = TaskGraphDefinition.first
    tgd2.definition = <<EOF
      task_group :governance do
        task :select_officers do
        end
      end
EOF
    tgd2.save

    assert_equal 2, TaskGraphDefinition.count
    assert_equal 2, TaskDefinition.count
    task_graph_definitions = TaskGraphDefinition.order(:version)
    old_task_graph_definition, new_task_graph_definition = task_graph_definitions
    assert_equal 1, old_task_graph_definition.version
    assert_equal false, old_task_graph_definition.current_revision
    old_task_definitions = old_task_graph_definition.task_definitions
    assert_equal 1, old_task_definitions.size
    assert_equal false, old_task_definitions.first.current_revision
    assert_equal "select_presidential_nominees", old_task_definitions.first.name.to_s
    assert_equal 2, new_task_graph_definition.version
    assert_equal true, new_task_graph_definition.current_revision
    new_task_definitions = new_task_graph_definition.task_definitions
    assert_equal true, new_task_definitions.first.current_revision
    assert_equal "select_officers", new_task_definitions.first.name.to_s
  end

  should "define task_group with one empty task" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees do
        end
      end
EOF
    assert tgd.valid?
    tgd.save
    assert_equal ["select_presidential_nominees"], TaskDefinition.all.map(&:name)
  end

  should "define a task_group with one non-empty task " do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
        task_group :governance do
          task :select_presidential_nominees do
            performed_by :board
          end
        end
EOF
    tgd.save
    assert_equal 1, TaskDefinition.count
    task_def = TaskDefinition.first
    assert_equal "board", task_def.role.name
  end

  should "define a task_group with two non-empty tasks" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.create(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominating_committee do
          performed_by :board
        end

        task :select_presidential_nominees do
          performed_by :presidential_nominating_committee
        end
      end
EOF
    assert_equal 2, TaskDefinition.count
    task_definitions = TaskDefinition.all.sort_by{|td| td.name}
    task_def = task_definitions.first
    assert_equal "select_presidential_nominating_committee", task_def.name
    assert_equal "board", task_def.role.name
    task_def = task_definitions.second
    assert_equal "select_presidential_nominees", task_def.name
    assert_equal "presidential_nominating_committee", task_def.role.name
  end

  should "define a task_group with two non-empty tasks that have a dependency" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.create(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominating_committee do
          performed_by :board
        end

        task :select_presidential_nominees => :select_presidential_nominating_committee do
          performed_by :presidential_nominating_committee
        end
      end
EOF

    assert_equal 2, TaskDefinition.count
    task_definitions = TaskDefinition.all.sort_by{|td| td.name}

    select_presidential_nominating_committee_task = task_definitions.first
    assert_equal "select_presidential_nominating_committee", select_presidential_nominating_committee_task.name
    assert_equal "board", select_presidential_nominating_committee_task.role.name
    assert_equal [], select_presidential_nominating_committee_task.dependencies

    select_presidential_nominees_task = task_definitions.second
    assert_equal "select_presidential_nominees", select_presidential_nominees_task.name
    assert_equal "presidential_nominating_committee", select_presidential_nominees_task.role.name
    assert_equal [select_presidential_nominating_committee_task], select_presidential_nominees_task.dependencies
  end

  should "define a task that has a non-existent dependency" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.create(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees => :select_presidential_nominating_committee do
          performed_by :presidential_nominating_committee
        end
      end
EOF
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_equal "missing dependency: select_presidential_nominating_committee", tgd.errors.first[1]
  end

=begin
  context "testing with existing task definitions" do
    setup do
      task_definition = FactoryGirl.create(:select_presidential_nominees_task_definition)
      task_definition.organization = @organization
      task_definition.save
    end

    should "define a task that is already defined by that name" do

      assert_raises(TaskGraph::TaskDefinitionAlreadyDefinedError) do
        TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
          task_group :governance do
            task :select_presidential_nominees do
            end
          end
EOF
      end
    end  

    should "update an already defined task of the same name" do
      assert_equal 1, TaskDefinition.count
      task_definitions = TaskDefinition.all.sort_by{|td| td.name}
      select_presidential_nominees_task = task_definitions.first

      assert_equal nil, select_presidential_nominees_task.role

puts "select_presidential_nominees.organization = #{select_presidential_nominees_task.organization_id}"

      TaskGraph.new.eval_task_definition(@organization, :update, <<EOF)
        task_group :governance do
          task :select_presidential_nominees do
            performed_by :board
          end
        end
EOF

      task_definitions = TaskDefinition.all.sort_by{|td| td.name}
      select_presidential_nominees_task = task_definitions.first
      assert_equal "select_presidential_nominees", select_presidential_nominees_task.name
      assert_equal "board", select_presidential_nominees_task.role.name
      assert_equal [], select_presidential_nominees_task.dependencies
    end  
  end
=end
end

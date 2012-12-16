require 'test_helper'

class MyTask < Task
  def set_options(options={})
    self.name += options[:option1]
  end
end

class MyOtherTask < Task
end

class TaskGraphDefinitionTest < ActiveSupport::TestCase
  setup do
    @organization = FactoryGirl.create(:pta)
  end
  should "catch syntax errors on definition" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
EOF
    tgd.save
    
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_match /syntax error/, tgd.errors.first[1]
  end

  should "define task_group with one task" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees 
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 2, Task.count
    governance_task = Task.find_by_name("governance")
    select_presidential_nominees_task = Task.find_by_name("select_presidential_nominees")
    assert_equal [select_presidential_nominees_task], governance_task.child_tasks
    assert_equal governance_task, select_presidential_nominees_task.parent_task
  end

  should "define task_group with one empty task" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees do
        end
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 2, Task.count
    assert_equal ["governance", "select_presidential_nominees"], Task.all.map(&:name).sort
  end


  should "define task_group with one empty custom task" do
    assert_equal 0, TaskGraphDefinition.count

    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_task :do_something
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 2, Task.count
    assert_equal 1, MyTask.count
    tgd = TaskGraphDefinition.first
    assert_equal ["do_something"], MyTask.all.map(&:name).sort
    assert_equal ["do_something", "governance"], Task.all.map(&:name).sort
  end

  should "define task_group with two empty custom task with no name for the first and and second dependent on it" do
    assert_equal 0, TaskGraphDefinition.count

    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_task
        my_task :next_task => :my_task
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 2, MyTask.count
    assert_equal ["my_task", "next_task"], MyTask.all.map(&:name)
  end

  should "define task_group with one empty custom task with an option" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_task :do_something, :option1 => "-extra"
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 1, MyTask.count
    tgd = TaskGraphDefinition.first
    assert_equal ["do_something-extra"], MyTask.all.map(&:name)
  end

  should "define task_group with one empty custom task that doesn't take options, with an option" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_other_task :do_something, :option1 => "-extra"
      end
EOF

    tgd.save
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_match /custom task class/, tgd.errors.first[1]
  end


  should "define task_group with one empty undefined custom task with an option" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_other_other_task :do_something, :option1 => "-extra"
      end
EOF

    tgd.save
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_match /unknown task type/, tgd.errors.first[1]
  end

  should "define task_group with a duplicate task name" do
    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :do_something
        task :do_something
      end
EOF

    tgd.save
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_match /already defined/, tgd.errors.first[1]
  end

  should "define task_group with one empty task and then redefine it" do
    assert_equal 0, TaskGraphDefinition.count

    tgd = TaskGraphDefinition.new(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees
      end
EOF
    tgd.save
    
    assert_equal 1, TaskGraphDefinition.count
    assert_equal 2, Task.count
    tgd = TaskGraphDefinition.first
    assert_equal true, tgd.current_revision
    assert_equal 1, tgd.version
    assert_equal ["governance", "select_presidential_nominees"], Task.all.map(&:name).sort

    tgd2 = TaskGraphDefinition.first
    tgd2.definition = <<EOF
      task_group :governance do
        task :select_officers
      end
EOF
    tgd2.save

    assert_equal 2, TaskGraphDefinition.unscoped.count
    assert_equal 4, Task.count
    task_graph_definitions = TaskGraphDefinition.unscoped.order(:version)
    old_task_graph_definition, new_task_graph_definition = task_graph_definitions
    assert_equal 1, old_task_graph_definition.version
    assert_equal false, old_task_graph_definition.current_revision
    old_task_definitions = old_task_graph_definition.task_definitions
    assert_equal 2, old_task_definitions.size
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
        task :select_presidential_nominees
      end
EOF
    assert tgd.valid?
    tgd.save
    assert_equal ["governance", "select_presidential_nominees"], Task.all.map(&:name).sort
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
    assert_equal 2, Task.count
    task_def = Task.find_by_name "select_presidential_nominees"
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
    assert_equal 3, Task.count
    task_definitions = Task.all.sort_by{|td| td.name}
    task_def = task_definitions.first
    assert_equal "governance", task_def.name
    task_def = task_definitions.second
    assert_equal "select_presidential_nominating_committee", task_def.name
    assert_equal "board", task_def.role.name
    task_def = task_definitions.third
    assert_equal "select_presidential_nominees", task_def.name
    assert_equal "presidential_nominating_committee", task_def.role.name
  end

  should "define a task_group with two non-empty tasks that have a dependency" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.create(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        my_task :select_presidential_nominating_committee do
          performed_by :board
        end

        task :select_presidential_nominees => :select_presidential_nominating_committee do
          performed_by :presidential_nominating_committee
        end
      end
EOF

    assert_equal 3, Task.count
    task_definitions = Task.all.sort_by{|td| td.name}

    governance_task = task_definitions.first
    assert_equal "governance", governance_task.name

    select_presidential_nominating_committee_task = task_definitions.second
    assert_equal "select_presidential_nominating_committee", select_presidential_nominating_committee_task.name
    assert_equal "board", select_presidential_nominating_committee_task.role.name
    assert_equal [], select_presidential_nominating_committee_task.dependencies

    select_presidential_nominees_task = task_definitions.third
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
  # TODO: NOT sure on this one: should roles have to exist or not?
  should "define a task that has a role assigned that doesn't exist" do
    #TaskGraph.instance.eval_task_definition(@organization, :create, <<EOF)
    tgd = TaskGraphDefinition.create(:organization => @organization, :definition => <<EOF)
      task_group :governance do
        task :select_presidential_nominees do
          performed_by :somebody
        end
      end
EOF
    assert_equal 1, tgd.errors.size
    assert_equal :definition, tgd.errors.first.first
    assert_equal "role doesn't exist: somebody", tgd.errors.first[1]
  end
=end
end

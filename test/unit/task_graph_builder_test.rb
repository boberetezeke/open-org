require "test_helper"

class TaskGraphBuilderTest < ActiveSupport::TestCase
  test "define task_group with one empty task" do
    TaskGraph.instance.eval_task_definition(<<EOF)
      task_group :governance do
        task :select_presidential_nominees do
        end
      end
EOF

    assert_equal ["select_presidential_nominees"], TaskDefinition.all.map(&:name)
  end

  test "define a task_group with one non-empty task " do
    TaskGraph.instance.eval_task_definition(<<EOF)
        task_group :governance do
          task :select_presidential_nominees do
            performed_by :board
          end
        end
EOF

    assert_equal 1, TaskDefinition.count
    task_def = TaskDefinition.first
    assert_equal "board", task_def.role.name
  end

  test "define a task_group with two non-empty tasks" do
    TaskGraph.instance.eval_task_definition(<<EOF)
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

  test "define a task_group with two non-empty tasks that have a dependency" do
    TaskGraph.instance.eval_task_definition(<<EOF)
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
    assert_equal [], select_presidential_nominating_committee_task.dependent_tasks

    select_presidential_nominees_task = task_definitions.second
    assert_equal "select_presidential_nominees", select_presidential_nominees_task.name
    assert_equal "presidential_nominating_committee", select_presidential_nominees_task.role.name
    assert_equal [select_presidential_nominating_committee_task], select_presidential_nominees_task.dependent_tasks
  end

  test "define a task that has a non-existent dependency" do
    assert_raises(TaskGraph::MissingDependencyError) do
      TaskGraph.instance.eval_task_definition(<<EOF)
        task_group :governance do
          task :select_presidential_nominees => :select_presidential_nominating_committee do
            performed_by :presidential_nominating_committee
          end
        end
EOF
    end
  end
end

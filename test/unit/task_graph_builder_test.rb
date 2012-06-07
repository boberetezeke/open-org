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
            performed_by :board do |arg|
            end
          end
        end
EOF

    assert_equal 1, TaskDefinition.count
    task_def = TaskDefinition.first
    assert_equal "board", task_def.role.name
  end
end

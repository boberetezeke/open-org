require "test_helper"

class TaskFieldTest < ActiveSupport::TestCase
  should "use the name as display name (humanized) if display name is not set" do
    @task_field = TaskField.create(:name => "the_name")
    assert_equal "The name", @task_field.display_name
  end

  should "use the display name if it is set" do
    @task_field = TaskField.create(:name => "the_name", :display_name => "some other name")
    assert_equal "some other name", @task_field.display_name
  end
end


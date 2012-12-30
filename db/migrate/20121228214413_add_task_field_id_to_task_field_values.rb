class AddTaskFieldIdToTaskFieldValues < ActiveRecord::Migration
  def change
    add_column :task_field_values, :task_field_id, :integer
  end
end

class AddTaskDefinitionIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_definition_id, :integer
  end
end

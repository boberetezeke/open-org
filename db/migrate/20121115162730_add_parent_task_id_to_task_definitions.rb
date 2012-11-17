class AddParentTaskIdToTaskDefinitions < ActiveRecord::Migration
  def change
    add_column :task_definitions, :parent_task_definition_id, :integer
  end
end

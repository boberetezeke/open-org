class AddTaskDefinitionIdToRole < ActiveRecord::Migration
  def change
    add_column :roles, :task_definition_id, :integer
  end
end

class AddRoleIdToTaskDefinition < ActiveRecord::Migration
  def change
    add_column :task_definitions, :role_id, :integer
  end
end

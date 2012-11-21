class AddOrganizationIdToTaskDefinitions < ActiveRecord::Migration
  def change
    add_column :task_definitions, :organization_id, :integer
  end
end

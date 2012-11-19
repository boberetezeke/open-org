class AddOrganizationToTaskGraphDefinition < ActiveRecord::Migration
  def change
    add_column :task_graph_definitions, :organization_id, :integer
  end
end

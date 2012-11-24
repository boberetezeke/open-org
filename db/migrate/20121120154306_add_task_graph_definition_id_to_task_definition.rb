class AddTaskGraphDefinitionIdToTaskDefinition < ActiveRecord::Migration
  def change
    add_column :task_definitions, :task_graph_definition_id, :integer
  end
end

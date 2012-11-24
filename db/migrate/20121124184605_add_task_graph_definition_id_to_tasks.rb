class AddTaskGraphDefinitionIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_graph_definition_id, :integer
  end
end

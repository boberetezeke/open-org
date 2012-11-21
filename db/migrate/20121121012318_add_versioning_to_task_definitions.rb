class AddVersioningToTaskDefinitions < ActiveRecord::Migration
  def change
    add_column :task_definitions, :current_revision, :boolean, :default => true
    add_column :task_graph_definitions, :version, :integer, :default => 1
    add_column :task_graph_definitions, :current_revision, :boolean, :default => true
  end
end

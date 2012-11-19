class CreateTaskGraphDefinitions < ActiveRecord::Migration
  def change
    create_table :task_graph_definitions do |t|
      t.text :definition
      t.timestamps
    end
  end
end

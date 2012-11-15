class AddTaskDependencyTable < ActiveRecord::Migration
  def up
    create_table :task_dependencies, :id => false do |t|
      t.integer :dependee_id
      t.integer :depender_id
    end
    create_table :task_definition_dependencies, :id => false do |t|
      t.integer :dependee_id
      t.integer :depender_id
    end
  end

  def down
    drop_table :task_dependencies
    drop_table :task_definition_dependencies
  end
end

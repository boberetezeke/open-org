class CreateTaskDefinitions < ActiveRecord::Migration
  def change
    create_table :task_definitions do |t|
      t.string :name
      t.text :definition
      t.integer :depends_on_task_definition

      t.timestamps
    end
  end
end

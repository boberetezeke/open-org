class RemoveTaskDefinitionsTables < ActiveRecord::Migration
  def up
    drop_table :task_definition_dependencies
    drop_table :task_definitions
  end

  def down
    create_table "task_definition_dependencies", :id => false, :force => true do |t|
      t.integer "dependee_id"
      t.integer "depender_id"
    end

    create_table "task_definitions", :force => true do |t|
      t.string   "name"
      t.text     "definition"
      t.integer  "depends_on_task_definition"
      t.datetime "created_at",                                   :null => false
      t.datetime "updated_at",                                   :null => false
      t.integer  "role_id"
      t.integer  "parent_task_definition_id"
      t.integer  "organization_id"
      t.integer  "task_graph_definition_id"
      t.boolean  "current_revision",           :default => true
    end
  end
end

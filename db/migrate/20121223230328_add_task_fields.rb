class AddTaskFields < ActiveRecord::Migration
  def up
    create_table :task_fields do |t|
      t.string :name
      t.string :data_type
      t.string :control_type
      t.string :choice_class_name
      t.string :choice_scope_name

      t.integer :task_id
    end

    create_table :task_field_values do |t|
      t.string :value
      t.integer :task_id
    end
  end

  def down
    drop_table :task_fields
    drop_table :task_field_values
  end
end

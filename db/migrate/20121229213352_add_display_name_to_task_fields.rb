class AddDisplayNameToTaskFields < ActiveRecord::Migration
  def change
    add_column :task_fields, :display_name, :string
  end
end

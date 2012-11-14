class AddTaskDescription < ActiveRecord::Migration
  def up
    add_column :tasks, :description, :string
  end

  def down
    remove_column :tasks, :description
  end
end

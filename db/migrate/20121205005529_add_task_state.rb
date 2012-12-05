class AddTaskState < ActiveRecord::Migration
  def up
    add_column :tasks, :state, :string
  end

  def down
    remove_column :tasks, :state
  end
end

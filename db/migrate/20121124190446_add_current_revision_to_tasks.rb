class AddCurrentRevisionToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :current_revision, :boolean, :default => true
  end
end

class AddPrimaryKeysToJoinTables < ActiveRecord::Migration
  def change
    add_column :memberships, :id, :primary_key
    add_column :assignments, :id, :primary_key
    add_column :task_dependencies, :id, :primary_key
  end
end

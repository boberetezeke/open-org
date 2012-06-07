class RenameAssignableTypeColumn < ActiveRecord::Migration
  def up
    remove_column :assignments, :assignable_type
    add_column :assignments, :assignable_type, :string
  end

  def down
    remove_column :assignments, :assignable_type
    add_column :assignments, :assignable_type, :integer
  end
end

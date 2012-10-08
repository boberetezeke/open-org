class OwnerTypeToString < ActiveRecord::Migration
  def up
    remove_column :tasks, :owner_type
    add_column :tasks, :owner_type, :string
  end

  def down
    remove_column :tasks, :owner_type
    add_column :tasks, :owner_type, :integer
  end
end

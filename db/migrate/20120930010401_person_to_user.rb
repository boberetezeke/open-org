class PersonToUser < ActiveRecord::Migration
  def up
    rename_table :people, :users
  end

  def down
    rename_table :users, :people
  end
end

class AddEmailAddress < ActiveRecord::Migration
  def up
    add_column :users, :email_address, :string
  end

  def down
    remove_column :users, :email_address
  end
end

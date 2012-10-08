class AddOrganizations < ActiveRecord::Migration
  def up
    create_table :organizations do |t|
      t.string :name
    end
    add_column :groups, :organization_id, :integer
  end

  def down
    drop_table :organizations
    remove_column :groups, :organization_id
  end
end

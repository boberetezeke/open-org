class RemoveIsOrganization < ActiveRecord::Migration
  def up
    remove_column :groups, :is_organization
  end

  def down
    add_column :groups, :is_organization, :boolean
  end
end

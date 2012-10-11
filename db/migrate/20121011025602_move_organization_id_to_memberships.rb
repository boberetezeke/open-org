class MoveOrganizationIdToMemberships < ActiveRecord::Migration
  def up
    add_column :memberships, :organization_id, :integer
    remove_column :groups, :organization_id
    remove_column :groups, :memberships_id
  end

  def down
    remove_column :memberships, :organization_id
    add_column :groups, :organization_id, :integer
  end
end

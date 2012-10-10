class AddWholeOrganizationFlag < ActiveRecord::Migration
  def up
    add_column :groups, :is_organization, :boolean
  end

  def down
    remove_column :groups, :is_organization
  end
end

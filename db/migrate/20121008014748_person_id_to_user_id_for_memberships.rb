class PersonIdToUserIdForMemberships < ActiveRecord::Migration
  def up
    rename_column :memberships, :person_id, :user_id
  end

  def down
    rename_column :memberships, :user_id, :person_id
  end
end

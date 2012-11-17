# This migration comes from open_org_meetings (originally 20121116214459)
class AddMeetingsTask < ActiveRecord::Migration
  def up
    add_column :tasks, :location, :string
  end

  def down
    remove_column :tasks, :location, :string
  end
end

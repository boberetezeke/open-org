class AddIsPrototypeToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :is_prototype, :boolean
  end
end

class InitialDatabase < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :name
    end

    create_table :memberships, :id => false do |t|
      t.integer :person_id
      t.integer :group_id
    end

    create_table :groups do |t|
      t.string :name
    end

    create_table :assignments do |t|
      t.integer :assignable_id
      t.integer :assignable_type
      t.integer :role_id
    end

    create_table :roles do |t|
      t.string :name
    end

    create_table :tasks do |t|
      t.string  :name
      t.integer :role_id
      t.integer :owner_id
      t.integer :owner_type

      t.integer :depends_on_task_id
      t.integer :parent_task_id
    end
  end

  def down
    drop_table :people
    drop_table :memberships
    drop_table :groups
    drop_table :assignments
    drop_table :roles
    drop_table :tasks
  end
end

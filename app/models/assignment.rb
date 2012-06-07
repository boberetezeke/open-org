class Assignment < ActiveRecord::Base
  belongs_to :assignable, :polymorphic => true
  belongs_to :role

  belongs_to :person,   :class_name => "Person",
                        :foreign_key => "assignable_id"
  belongs_to :group,    :class_name => "Group",
                        :foreign_key => "assignable_id"
end

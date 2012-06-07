class Role < ActiveRecord::Base
  has_many :assignments

  has_many :people,   :through => :assignments, :source => :person,
                      :conditions => "assignments.assignable_type = 'Person'"
  has_many :groups,   :through => :assignments, :source => :group,
                      :conditions => "assignments.assignable_type = 'Group'"
  has_many :task_definitions
end


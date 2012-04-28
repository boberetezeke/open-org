class Role
  has_many :assignments
  has_many :people, :through 

  has_many :people,   :through => :assignments, :source => :person,
                      :conditions => "assignments.assignable_type = 'Person'"
  has_many :group,    :through => :assignments, :source => :group,
                      :conditions => "assignments.assignable_type = 'Group'"
end


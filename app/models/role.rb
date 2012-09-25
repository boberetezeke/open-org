class Role < ActiveRecord::Base
  has_many :assignments

  has_many :people,   :through => :assignments, :source => :assignable,
                                                :source_type => "Person"
  has_many :groups,   :through => :assignments, :source => :assignable,
                                                :source_type => "Group"
  has_many :task_definitions
end


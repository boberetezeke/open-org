class Role < ActiveRecord::Base
  has_many :assignments

  has_many :users,   :through => :assignments, :source => :assignable,
                                                :source_type => "User"
  has_many :groups,   :through => :assignments, :source => :assignable,
                                                :source_type => "Group"
  has_many :task_definitions
end


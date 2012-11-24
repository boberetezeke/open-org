class Role < ActiveRecord::Base
  belongs_to :organization
  has_many :assignments

  has_many :users,   :through => :assignments, :source => :assignable,
                                                :source_type => "User"
  has_many :groups,   :through => :assignments, :source => :assignable,
                                                :source_type => "Group"
  has_many :task_definitions, :class_name => "Task", :foreign_key => :role_id, :conditions => {:is_prototype => true}
end


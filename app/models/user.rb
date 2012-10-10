class User < ActiveRecord::Base
  has_many :tasks, :as => :owner
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments
  has_many :groups, :through => :memberships
  has_many :memberships
  has_many :votes

  def organizations
    self.groups.where(:is_organization => true)
  end

  def assigned_tasks
    self.tasks
  end
end


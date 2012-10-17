class User < ActiveRecord::Base
  attr_accessible :email_address, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create

  has_many :memberships
  has_many :tasks, :as => :owner
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments
  has_many :groups, :through => :memberships
  has_many :organizations, :through => :memberships
  has_many :organizational_groups, :through => :organizations, :source => :groups
  has_many :votes

  def assigned_tasks
    self.tasks
  end
end


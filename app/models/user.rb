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

  def self.ungrouped
    mt = Membership.arel_table
    user_ids_in_groups = Membership.where(mt[:group_id].eq(nil).not).map{|m| m.user_id}.reject{|u| u.nil?}
    ut = User.arel_table
    User.where(ut[:id].in(user_ids_in_groups).not)
  end

  def assigned_tasks
    self.tasks
  end

  def can_access_task_definition?(task_definition)
    roles.each do |role|
      if role.task_definitions.map{|task_def| task_def.id}.include?(task_definition.id)
        return true
      end
    end
    return false
  end
end


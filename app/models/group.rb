class Group < ActiveRecord::Base
  has_many :memberships
  has_many :tasks, :as => :owner
  has_many :organizations, :through => :memberships
  has_many :users, :through => :memberships
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments

  def self.occupied
    mt = Membership.arel_table
    group_ids_in_memberships = Membership.where(mt[:user_id].eq(nil).not).map{|m| m.group_id}.reject{|g| g.nil?}.uniq
    gt = Group.arel_table
    Group.where(gt[:id].in(group_ids_in_memberships))
  end

  def self.empty
    mt = Membership.arel_table
    group_ids_in_memberships = Membership.where(mt[:user_id].eq(nil).not).map{|m| m.group_id}.reject{|g| g.nil?}.uniq
    gt = Group.arel_table
    Group.where(gt[:id].in(group_ids_in_memberships).not)
  end
end


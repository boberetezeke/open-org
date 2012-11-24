class Organization < ActiveRecord::Base
  has_many :roles
  has_many :memberships
  has_many :task_definitions
  has_many :task_graph_definitions
  has_many :groups, :through => :memberships
  has_many :users, :through => :memberships
end

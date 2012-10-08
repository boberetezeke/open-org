class Group < ActiveRecord::Base
  belongs_to :organization
  has_many :memberships
  has_many :tasks, :as => :owner
  has_many :users, :through => :memberships
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments
end


class Group < ActiveRecord::Base

  has_many :memberships
  has_many :users, :through => :memberships
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments
end


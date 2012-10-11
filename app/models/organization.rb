class Organization < ActiveRecord::Base
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :users, :through => :memberships
end

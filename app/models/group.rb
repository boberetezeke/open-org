class Group
  has_many :memberships
  has_many :people, :through => :memberships
  has_many :assignments, :as => :assignable
  has_many :roles, :through => :assignments
end


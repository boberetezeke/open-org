class Person
  has_many :assignments, :as => :assignables
  has_many :roles, :through => :assignments
  has_many :memberships
  has_many :groups, :through => :memberships
end


class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :group
  belongs_to :user
end

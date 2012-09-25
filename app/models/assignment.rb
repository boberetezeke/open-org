class Assignment < ActiveRecord::Base
  belongs_to :assignable, :polymorphic => true
  belongs_to :role
end

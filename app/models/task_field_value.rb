class TaskFieldValue < ActiveRecord::Base
  belongs_to :task
  belongs_to :task_field
end

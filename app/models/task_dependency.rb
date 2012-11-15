class TaskDependency < ActiveRecord::Base
  belongs_to :dependent_task, :class_name => Task, :foreign_key => :dependee_id
  belongs_to :dependee_task,  :class_name => Task, :foreign_key => :depender_id
end

class TaskDefinition < ActiveRecord::Base
  belongs_to :role
  belongs_to :task_definition, :foreign_key => :depends_on_task_definition
  has_many :dependent_tasks, :class_name => "TaskDefinition", :foreign_key => :depends_on_task_definition
end

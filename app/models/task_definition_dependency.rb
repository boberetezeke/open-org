class TaskDefinitionDependency < ActiveRecord::Base
  belongs_to :dependent_task_definition, :class_name => TaskDefinition, :foreign_key => :dependee_id
  belongs_to :dependee_task_definition,  :class_name => TaskDefinition, :foreign_key => :depender_id
end

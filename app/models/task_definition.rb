class TaskDefinition < ActiveRecord::Base
  belongs_to :role
  belongs_to :depended_on_task, :foreign_key => :depends_on_task_definition
  has_many :dependent_tasks, :class_name => "TaskDefinition", :foreign_key => :depends_on_task_definition

  def performed_by(role_name)
    role = Role.where(:name => role_name.to_s).first
    if !role then
      role = Role.create(:name => role_name.to_s)
    end
    self.role = role
  end

  def starts_when(&block)
    @starts_when_proc = block
  end

  def completed_when(&block)
    @completed_when_proc = block
  end

  def on_activation(&block)
    @on_activation_proc = block
  end

  def on_completion(&block)
    @on_completion_proc = block
  end
end

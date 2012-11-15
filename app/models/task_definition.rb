class TaskDefinition < ActiveRecord::Base
  belongs_to :role

  has_many :dependers, class_name: 'TaskDefinitionDependency', foreign_key: :dependee_id
  has_many :dependees, class_name: 'TaskDefinitionDependency', foreign_key: :depender_id

  has_many :dependencies, through: :dependees, :source => :dependent_task_definition
  has_many :depending_on, through: :dependers, :source => :dependee_task_definition

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

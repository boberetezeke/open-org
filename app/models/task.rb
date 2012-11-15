class Task < ActiveRecord::Base
  cattr_accessor :depends_on_name

  has_many :dependers, class_name: 'TaskDependency', foreign_key: :dependee_id
  has_many :dependees, class_name: 'TaskDependency', foreign_key: :depender_id

  has_many :dependencies, through: :dependees, :source => :dependent_task
  has_many :depending_on, through: :dependers, :source => :dependee_task

  belongs_to  :owner,       :polymorphic => true
  belongs_to  :role

  belongs_to  :prototype,   :class_name => "TaskDefinition", :foreign_key => :task_definition_id

  belongs_to  :parent_task, :class_name => "Task", :foreign_key => :parent_task_id
  has_many    :child_tasks, :class_name => "Task", :foreign_key => :parent_task_id

  # for those tasks that have votes for them to proceed
  has_many    :votes

  scope :in_priority_order, order(:priority)

  #validates_format_of :name, :with => /task/

  def initialize(*args)
    super(*args)
    if args.first.is_a?(Hash)
      initializers = args.first
      if task_definition = initializers[:prototype] then
        setup_task_definition_defaults(task_definition)
      end
    end
  end

  def setup_task_definition_defaults(task_definition)
    self.role = task_definition.role
    select_owner
  end

  def select_owner
    self.owner = self.role.users.empty? ? self.role.groups.first : self.users.first
  end

end

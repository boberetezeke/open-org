class Task < ActiveRecord::Base
  cattr_accessor :depends_on_name

  has_many :dependers, class_name: 'TaskDependency', foreign_key: :dependee_id
  has_many :dependees, class_name: 'TaskDependency', foreign_key: :depender_id

  has_many :dependencies, through: :dependees, :source => :dependent_task
  has_many :depending_on, through: :dependers, :source => :dependee_task

  # only applies if is_prototype is false
  belongs_to  :owner,       :polymorphic => true
  belongs_to  :prototype,   :class_name => "Task", :foreign_key => :task_definition_id, :conditions => {:is_prototype => true}
  belongs_to  :parent_task, :class_name => "Task", :foreign_key => :parent_task_id
  has_many    :child_tasks, :class_name => "Task", :foreign_key => :parent_task_id

  # for those tasks that have votes for them to proceed
  has_many    :votes

  # only applies if is_prototype is true
  belongs_to  :organization
  belongs_to  :role
  belongs_to  :task_graph_definition

  scope :in_priority_order, order(:priority)

  #validates_format_of :name, :with => /task/


  #cattr_accessor :registered_classes
  
  def Task.inherited(klass)
    super
    @registered_classes ||= {}
    @registered_classes[klass.to_s.tableize.singularize] = klass
  end

  def Task.registered_classes
    @registered_classes ||= {}
    @registered_classes
  end

  # only used when is_prototype is false
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

  # only used when is_prototype is true
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

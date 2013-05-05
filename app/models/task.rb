require "set"

class Task < ActiveRecord::Base
  attr_accessible :name, :prototype

  cattr_accessor :depends_on_name

  has_many :dependers, class_name: 'TaskDependency', foreign_key: :dependee_id
  has_many :dependees, class_name: 'TaskDependency', foreign_key: :depender_id

  has_many :dependencies, through: :dependees, :source => :dependent_task
  has_many :depending_on, through: :dependers, :source => :dependee_task

  belongs_to  :parent_task, :class_name => "Task", :foreign_key => :parent_task_id
  has_many    :child_tasks, :class_name => "Task", :foreign_key => :parent_task_id

  after_create     :create_task_fields

  #after_initialize :load_task_field_values
  after_save       :save_task_field_values

  # only applies if is_prototype is false
  belongs_to  :owner,       :polymorphic => true
  belongs_to  :prototype,   :class_name => "Task", :foreign_key => :task_definition_id, :conditions => {:is_prototype => true}
  has_many    :task_field_values

  # only applies if is_prototype is true
  belongs_to  :organization

  belongs_to  :role
  belongs_to  :task_graph_definition
  has_many    :task_fields

  # for those tasks that have votes for them to proceed
  has_many    :votes

  scope :in_priority_order, order(:priority)

  #validates_format_of :name, :with => /task/


  #cattr_accessor :registered_classes
  @@registered_classes = {}
  def Task.inherited(klass)
    super
    @@registered_classes[klass.to_s.tableize.singularize] = klass
  end

  def Task.registered_classes
    @@registered_classes
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

  def prototype=(task_definition)
    super
    setup_task_definition_defaults(task_definition)
  end

  def setup_task_definition_defaults(task_definition)
    self.role = task_definition.role
    select_owner if self.role
  end

  def select_owner
    self.owner = self.role.users.empty? ? self.role.groups.first : self.role.users.first
  end

  def new_task
    task = self.dup
    task.is_prototype = false
    task.prototype = self
    task.organization = self.organization
    task
  end

  # only used when is_prototype is true

  def name_with_role
    "#{self.name} (#{self.organization.name} - #{self.role.name})"
  end

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

  define_callbacks :activation, :completion
  
  def self.before_activation(*args, &block)
    set_callback(:activation, :before, *args, &block)
  end

  def self.after_activation(*args, &block)
    set_callback(:activation, :after, *args, &block)
  end

  def self.before_completion(*args, &block)
    set_callback(:completion, :before, *args, &block)
  end

  def self.after_completion(*args, &block)
    set_callback(:completion, :after, *args, &block)
  end
=begin
  def on_activation(&block)
    @on_activation_proc = block
  end

  def on_completion(&block)
    @on_completion_proc = block
  end
=end

=begin
  def save
    if !self.is_prototype
      run_callbacks(:activation) { super }
    else
      super
    end
  end
=end

  def add_task_field(task_field)
    @task_fields_hash[task_field.name] = task_field
  end

  def method_missing(sym, *args, &block)
    if !(self.is_prototype) then
      load_task_field_values
      method_name = sym.to_s
      if method_name =~ /^(.*)=/ then
        method_name = $1
        if task_field = @task_fields[method_name] then
          if task_field_value = @task_field_values[method_name] then
            task_field_value.value = args.first
          else
            @task_field_values[method_name] = 
              TaskFieldValue.new(:task => self, :task_field => task_field, :value => args.first)
          end
          @task_field_values_changed.add(method_name)
        else
          raise "task field not defined for #{method_name}"
        end

        #method_name_task_fields = self.prototype.task_fields.where(:name => method_name)
        #if method_name_task_fields.empty?
        #  raise "task field not defined for #{method_name}"
        #else
        #  task_field_values = task_field_values_for_method_name(method_name)
        #  if task_field_values.empty?
        #    self.task_field_values << TaskFieldValue.new(:value => args.first, :task_field => method_name_task_fields.first)
        #  else
        #    TaskFieldValue.find(task_field_values.first.id).update_attributes(:value => args.first)
        #  end
        #end
      else
        if @task_fields[method_name] then
          task_field_value = @task_field_values[method_name]
          task_field_value.nil? ? nil : task_field_value.value
        else
          raise "task field not defined for #{method_name}"
        end

        #task_field_values = task_field_values_for_method_name(method_name)
        #if task_field_values.present? then
        #  return task_field_values.first.value
        #else
        #  task_fields = self.task_fields.where(:name => method_name)
        #  return nil if task_fields.present?
        #end
      end
    end

    #super
  end

  class << self
    attr_accessor :defined_task_fields

    def task_field(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @defined_task_fields = args.flatten.map do |task_field_name| 
        default_options = {
           :name => task_field_name, 
           :data_type => "string",
           :control_type => "text_field"
        }
        TaskField.new(default_options.merge(options))
      end
    end

    def defined_task_fields
      @defined_task_fields ||= []
    end
  end

  private

  # if is_prototype is true
  
  def create_task_fields
    return unless is_prototype

    self.class.defined_task_fields.each do |task_field|
      new_task_field = task_field.dup
      new_task_field.task_id = self.id
      new_task_field.save
    end
  end

  # if is_prototype is false

  def load_task_field_values
    return if @task_fields

    @task_fields = {}
    @task_field_values = {} 
    @task_field_values_changed = Set.new
    self.prototype.task_fields.each do |tf|
      @task_fields[tf.name] = tf
    end
    self.task_field_values.includes(:task_field).each do |task_field_value|
      @task_field_values[task_field_value.task_field.name] = task_field_value
    end
  end

  def save_task_field_values
    return unless @task_field_values_changed
    @task_field_values_changed.each do |task_field_name|
      @task_field_values[task_field_name].save
    end
    @task_field_values_changes = Set.new
  end

=begin
  def task_field_values_for_method_name(method_name)
    # if this is a new record, then the objects won't be saved to the database yet
    if self.new_record? then
      task_field_values = self.task_field_values.select{|tfv| tfv.task_field.name == method_name}
    else
      task_field_values = self.task_field_values.joins{task_field}.where{task_field.name == method_name}
    end
  end
=end

end

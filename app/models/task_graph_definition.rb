class TaskGraphDefinition < ActiveRecord::Base
  belongs_to :organization
  has_many :task_definitions, :class_name => "Task", :foreign_key => :task_graph_definition_id, :conditions => {:is_prototype => true}

  before_validation :clear_out_task_definitions
  validate :validate_definition

  default_scope where(:current_revision => true)

  attr_reader :new_id

  def initialize(*args)
    super

    @validated_tasks = []
  end

  def save
    if self.new_record? || !self.current_revision
      super
    else
      old_task_graph_definition = TaskGraphDefinition.unscoped.find(self.id)
      old_task_definitions = old_task_graph_definition.task_definitions

      begin
        self.transaction do
          new_old_task_graph_definition = self.class.new #old_task_graph_definition.dup
          new_old_task_graph_definition.current_revision = false
          new_old_task_graph_definition.save
          old_task_definitions.each do |task_definition|
            task_definition.current_revision = false
            task_definition.task_graph_definition = new_old_task_graph_definition
            task_definition.save
          end
          self.version = old_task_graph_definition.version + 1
          super
        end
      end
    end
  end

  private

  def clear_out_task_definitions
    return unless self.current_revision

    self.task_definitions = []
  end

  def validate_definition
    return unless self.current_revision

    if self.organization.nil?
      errors.add(:organization, "cannot be blank")
      return false
    end

    task_graph_builder = TaskGraphBuilder.new(self, organization)
    begin
      task_graph_builder.instance_eval(self.definition)
    rescue TaskGraphBuilder::Error => e
      errors.add(:definition, e.message)
      return false
    end
  end


end

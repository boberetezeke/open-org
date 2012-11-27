class Builder
  def instance_exec(*args, &block)
    method_name = nil
    Thread.exclusive do
      n = 0
      n += 1 while respond_to?(method_name = "__instance_exec#{n}")
      self.class.instance_eval { define_method(method_name, &block) }
    end

    begin
      send(method_name) # *args)
    ensure
      self.class.instance_eval { remove_method(method_name) } rescue nil
    end
  end
end

class TaskDefinitionBuilder < Builder
  def initialize(task_definition)
    @task_definition = task_definition
  end

  def method_missing(sym, *args, &block)
    @task_definition.send(sym, *args, &block)
  end
end

class TaskGroupBuilder < Builder
  attr_reader :tasks

  def initialize(task_graph_definition, organization)
    @task_graph_definition = task_graph_definition
    @organization = organization
    @tasks = {}
  end

  TASK_OPTIONS = [:task_name, :task_class]
  def task(task_name_or_hash, &block)

    dependent_task_symbols = []
    if task_name_or_hash.is_a?(Symbol)
      task_name = task_name_or_hash
      task_class = Task
    elsif task_name_or_hash.is_a?(Hash)
      task_class = task_name_or_hash.delete(:task_class) || Task
      task_name_symbol = task_name_or_hash.delete(:task_name) ||
                         task_name_or_hash.keys.first ||
                         task_class.tableize.singularize
      task_name = task_name_symbol.to_s
      dependent_task_or_tasks = task_name_or_hash[task_name_symbol]
      if dependent_task_or_tasks then
        if dependent_task_or_tasks.is_a?(Array) 
          dependent_task_symbols = dependent_task_or_tasks
        else
          dependent_task_symbols = [dependent_task_or_tasks]
        end
      end
    end
#puts "task_class = #{task_class}"
#puts "task_name = #{task_name}"
#puts "dependent_task_symbols = #{dependent_task_symbols.inspect}"

    task_defs = @task_graph_definition.task_definitions.select{|task_def| task_def.name.to_s == task_name.to_s}
    if task_defs.empty? then
      task_definition = task_class.new(:name => task_name, :organization => @organization, :is_prototype => true)
    else
      raise TaskGraphBuilder::TaskDefinitionDuplicateSymbolError.new(task_name)
    end
    task_definition_builder = TaskDefinitionBuilder.new(task_definition)
    task_definition_builder.instance_exec(task_definition, &block)
      
=begin
    task_definitions = TaskDefinition.where(:name => name.to_s, :organization_id => @organization.id)
    task_definition = task_definitions.first if task_definitions.present?
    if @task_graph_definition.new_record?
      raise TaskGraphBuilder::TaskDefinitionAlreadyDefinedError.new(name) if task_definition
    end
    task_definition_builder = TaskDefinitionBuilder.new(task_definition)
    task_definition_builder.instance_exec(task_definition, &block)
=end

    task_definition.dependencies = dependent_task_symbols.map do |dependent_task_symbol|
      #dependent_task_definition = TaskDefinition.find_by_name(dependent_task_symbol.to_s)
      #if !dependent_task_definition
      task_defs = @task_graph_definition.task_definitions.select{|task_def| task_def.name.to_s == dependent_task_symbol.to_s}
      if task_defs.empty?
        raise TaskGraphBuilder::MissingDependencyError.new(dependent_task_symbol.to_s) 
      else
        task_defs.first
      end
    end

    @task_graph_definition.task_definitions << task_definition
    task_definition
  end

  def method_missing(sym, *args, &block)
    # attempt to load class
    sym.to_s.camelize.constantize rescue nil
    if task_class = Task.registered_classes[sym.to_s] then
      if args.size == 1 then
        name_or_hash = args.first
        if name_or_hash.is_a?(Hash) then
          return task(name_or_hash.merge(:task_class => task_class), &block)
        else
          return task(:task_name => name_or_hash, :task_class => task_class, &block)
        end
      elsif args.size == 2 then
        if args[0].is_a?(Symbol) && args[1].is_a?(Hash)
          new_task = task({:task_name => args[0], :task_class => task_class}, &block)
          if new_task.respond_to?(:set_options)
            new_task.set_options(args[1])
          else
            raise TaskGraphBuilder::CustomTaskDoesntSupportOptionsError.new(task_class)
          end
          return new_task
        end
      end
      args_array = *args
      raise TaskGraphBuilder::InvalidTaskSyntax.new("only a task name or hash is allowed from args = #{args_array.inspect}")
    else
      raise TaskGraphBuilder::UnknownTaskTypeError.new(sym, Task.registered_classes)
    end
  end
end

class TaskGraphBuilder < Builder
  class Error < Exception; end

  class MissingDependencyError < Error
    attr_reader :task_dependency_name_symbol
    def initialize(task_dependency_name_symbol)
      @task_dependency_name_symbol = task_dependency_name_symbol
    end

    def to_s
      I18n.t("task_graph_builder.missing_dependency_error", :task_dependency_name => @task_dependency_name_symbol.to_s) 
    end
  end

  class TaskDefinitionDuplicateSymbolError < Error
    attr_reader :task_definition_name_symbol
    def initialize(task_definition_name_symbol)
      @task_definition_name_symbol = task_definition_name_symbol
    end

    def to_s
      I18n.t("task_graph_builder.task_definition_duplicate_symbol_error", :task_definition_name => @task_definition_name_symbol.to_s)
    end
  end

  class UnknownTaskTypeError < Error
    attr_reader :task_type_symbol
    def initialize(task_type_symbol, registered_classes)
      @task_type_symbol = task_type_symbol
      @registered_classes = registered_classes
    end

    def to_s
      I18n.t("task_graph_builder.unknown_task_type_error", :task_type => @task_type_symbol.to_s, :registered_classes => @registered_classes.keys.inspect)
    end
  end

  class InvalidTaskSyntax < Error; end
  class CustomTaskDoesntSupportOptionsError < Error
    def initialize(task_class)
      @task_class = task_class
    end

    def to_s
      I18n.t("task_graph_builder.custom_task_doesnt_support_options_error", :task_class => @task_class.to_s)
    end
  end

  class InvalidTaskSyntax < Error; end

  attr_reader :tasks
  def initialize(task_graph_definition, organization)
    @task_graph_definition = task_graph_definition
    @organization = organization
    @tasks = []
  end

  def task_group(group_name, &block)
    task_group_builder = TaskGroupBuilder.new(@task_graph_definition, @organization)
    task_group_builder.instance_exec(&block)
    @tasks += task_group_builder.tasks.values
  end
end


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

  def task(task_name_or_hash, &block)

    if task_name_or_hash.is_a?(Hash)
      # assume there is only one key, and it is a symbol
      # assume for that key there is either one symbol or a single level array of symbols
      task_name_symbol = task_name_or_hash.keys.first
      name = task_name_symbol.to_s
      dependent_task_or_tasks = task_name_or_hash[task_name_symbol]
      if dependent_task_or_tasks.is_a?(Array) 
        dependent_task_symbols = dependent_task_or_tasks
      else
        dependent_task_symbols = [dependent_task_or_tasks]
      end
    else
      # assume that this is a symbol
      name = task_name_or_hash.to_s
      dependent_task_symbols = []
    end

    task_defs = @task_graph_definition.task_definitions.select{|task_def| task_def.name.to_s == name.to_s}
    if task_defs.empty? then
      task_definition = Task.new(:name => name, :organization => @organization, :is_prototype => true)
    else
      raise TaskGraphBuilder::TaskDefinitionAlreadyDefinedError.new(name) if task_definition
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
      "missing dependency: #{@task_dependency_name_symbol}"
    end
  end

  class TaskDefinitionAlreadyDefinedError < Error
    attr_reader :task_definition_name_symbol
    def initialize(task_definition_name_symbol)
      @task_definition_name_symbol = task_definition_name_symbol
    end
  end

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


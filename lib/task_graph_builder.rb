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

    task_definition = TaskDefinition.new(:name => name)
    task_definition_builder = TaskDefinitionBuilder.new(task_definition)
    task_definition_builder.instance_exec(task_definition, &block)

    task_definition.dependent_tasks = dependent_task_symbols.map do |dependent_task_symbol|
      dependent_task_definition = TaskDefinition.find_by_name(dependent_task_symbol.to_s)
      raise TaskGraph::MissingDependencyError.new(dependent_task_symbol.to_s) unless dependent_task_definition
      dependent_task_definition
    end

    task_definition.save
    tasks = TaskDefinition.all
  end
end

class TaskGraphBuilder < Builder
  def task_group(group_name, &block)
    task_group_builder = TaskGroupBuilder.new
    task_group_builder.instance_exec(&block)
  end
end


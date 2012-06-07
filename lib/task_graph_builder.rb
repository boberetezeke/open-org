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
    rescue Exception => e
      puts "Exception: #{e.message}"
    ensure
      self.class.instance_eval { remove_method(method_name) } rescue nil
    end
  end
end

class TaskDefinitionBuilder < Builder
  def initialize(task_definition)
    @task_definition = task_definition
  end

  def performed_by(role_name)
    role = Role.where(:name => role_name.to_s).first
    if !role then
      role = Role.create(:name => role_name.to_s)
    end
    @task_definition.role = role
  end

end

class TaskGraphBuilder < Builder
  def task_group(group_name, &block)
    task_group_builder = TaskGroupBuilder.new
    task_group_builder.instance_exec(&block)
  end

end

class TaskGroupBuilder < Builder
  def task(task_name, &block)

    task_definition = TaskDefinition.new(:name => task_name.to_s)
    task_definition_builder = TaskDefinitionBuilder.new(task_definition)
    task_definition_builder.instance_exec(task_definition, &block)
    task_definition.save
    tasks = TaskDefinition.all
  end
end

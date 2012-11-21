class TaskGraph
  class MissingDependencyError < Exception
    attr_reader :task_dependency_name_symbol
    def initialize(task_dependency_name_symbol)
      @task_dependency_name_symbol = task_dependency_name_symbol
    end
  end

  class TaskDefinitionAlreadyDefinedError < Exception
    attr_reader :task_definition_name_symbol
    def initialize(task_definition_name_symbol)
      @task_definition_name_symbol = task_definition_name_symbol
    end
  end

  def self.instance
    @task_graph ||= self.new
  end

  POSSIBLE_ACTIONS = [:create, :update]

  def eval_task_definition(organization, action, text)
    raise "action not in possible actions: #{POSSIBLE_ACTIONS.inspect}" unless POSSIBLE_ACTIONS.include?(action)
    task_graph_builder = TaskGraphBuilder.new(organization, action)
    task_graph_builder.instance_eval(text)
  end
end

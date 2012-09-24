class TaskGraph
  class MissingDependencyError < Exception
    attr_reader :task_dependency_name_symbol
    def initialize(task_dependency_name_symbol)
      @task_dependency_name_symbol = task_dependency_name_symbol
    end
  end

  def self.instance
    @task_graph ||= self.new
  end

  def eval_task_definition(text)
    task_graph_builder = TaskGraphBuilder.new
    task_graph_builder.instance_eval(text)
  end
end

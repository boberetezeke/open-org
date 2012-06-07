class TaskGraph
=begin
  #include "celluloid"
  attr_reader :classes, :class_infos

  class ClassInfo
    attr_accessor :klass, :task
    def initialize(klass)
      @klass = klass
      @task = nil
    end
    
    def task
      unless @task
        @task = @klass.new
        @task.is_prototype = true
      end
      @task
    end

    def class_name
      @klass.to_s
    end
  end
=end
  def self.instance
    @task_graph ||= self.new
  end
=begin
  def initialize
    @classes = []
    @class_infos = {}
  end

  def add_class(klass)
puts "add_class called with #{klass.inspect}"
    class_infos[klass] = ClassInfo.new(klass)
    classes.push(klass)
  end
=end

  def eval_task_definition(text)
    task_graph_builder = TaskGraphBuilder.new
    task_graph_builder.instance_eval(text)
  end

=begin
  def eval_task_definition(text)
    current_classes = self.classes.dup
puts "current_classes = #{current_classes.inspect}"
    eval(text)
    added_classes = self.classes - current_classes
    new_tasks = []

    # hook up tasks
    added_classes.each do |klass|
      class_info = class_infos[klass]
      class_info.klass.where(:is_prototype => true).each do |prototype|
        prototype.destroy
      end

      task = class_info.task
      new_tasks.push(task)
      if klass.depends_on_name
        task.depends_on = classes[class_info.klass.depends_on_name].task
      end
    end

    # 
    new_tasks.each do |task|
      task.save
    end
  end
=end
end

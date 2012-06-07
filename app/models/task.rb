class Task < ActiveRecord::Base
  class << self
    def depends_on(task_names)
      @depends_on_names = task_names
    end

    def performed_by(role)
      @performed_by_role = role
    end

    def starts_when(&block)
      @starts_when_proc = block
    end

    def completed_when(&block)
      @completed_when_proc = block
    end

    def on_completion(&block)
      @on_completion_proc = block
    end

    def inherited(klass)
      TaskGraph.instance.add_class(klass)
    end
  end

  cattr_accessor :depends_on_name

  belongs_to  :owner,       :polymorphic => true
  belongs_to  :role

  belongs_to  :depends_on,  :class_name => "Task", :foreign_key => :depends_on_task_id
  has_many    :dependents,  :class_name => "Task", :foreign_key => :depends_on_task_id

  belongs_to  :parent_task, :class_name => "Task", :foreign_key => :parent_task_id
  has_many    :child_tasks, :class_name => "Task", :foreign_key => :parent_task_id

  # for those tasks that have votes for them to proceed
  has_many    :votes
end

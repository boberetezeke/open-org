class WorkFlower
  def set_task_state(task, current_user, new_state)
    if new_state.to_s == "in_progress"
      task.state = "in_progress"
      task.save 
    elsif new_state.to_s == "done"
      task.state = "done"
      task.save

      # for each task that depends on this one
      task.prototype.depending_on.each do |task_def|
        # bring a new task into existence
        # FIXME: find task instead of creating one if it was brought into
        #        existence by one of its other dependencies
        dep_task = task_def.new_task

        # assign an owner to it 
        # FIXME: should that be done here
        if task_def.role.users.present? 
          dep_task.owner = task_def.role.users.first
        elsif task_def.role.groups.present?
          dep_task.owner = task_def.role.groups.first
        end

        # determine if the task should be activated or not
        dep_task.dependencies << task
        if dep_task.dependencies.size == dep_task.prototype.dependencies.size
          dep_task.state = "in_progress"
        else
          dep_task.state = "waiting"
        end
        dep_task.save
      end
    end
  end
end

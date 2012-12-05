class WorkFlower
  def set_task_state(task, current_user, new_state)
    if new_state == :in_progress
      task.state = "in_progress"
      task.save 
    elsif new_state == :done
      task.state = "done"
      task.save

      task.prototype.depending_on.each do |task_def|
        task = task_def.create_task
        if task_def.role.users.present? 
          task.owner = task_def.role.users.first
        elsif task_def.role.groups.present?
          task.owner = task_def.role.groups.first
        end
        task.save
      end
    end
  end
end

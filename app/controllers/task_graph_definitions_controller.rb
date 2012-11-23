class TaskGraphDefinitionsController < InheritedResources::Base
  belongs_to :organization, :shallow => true

  def update
    task_graph_definition = TaskGraphDefinition.find(params[:id])
    if task_graph_definition.update_attributes(params[:task_graph_definition]) then
      redirect_to task_graph_definition_path(TaskGraphDefinition.find(task_graph_definition.new_id))
    else
      redirect_to edit_task_graph_definition_path(task_graph_definition)
    end
  end
end

class TaskGraphDefinitionsController < InheritedResources::Base
  belongs_to :organization

  def update
    old_task_graph_definition = TaskGraphDefinition.find(params[:id])
    old_task_definitions = old_task_graph_definitions.task_definitions
    new_task_graph_definition = TaskGraphDefinition.new(:definition => params[:definition])
    begin
      TaskGraphDefinition.transaction do
        old_task_definitions.each do |task_definition|
          task_definition.current_revision = false
          task_definition.save
        end
        old_task_graph_definition.current_revision = false
        new_task_graph_definition.version = old_task_graph_definition.version + 1
        new_task_graph_definition.save
      end
    rescue Exception => e
      redirect_to :edit
      return
    end

    redirect_to :show
  end
end

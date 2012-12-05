class TasksController < ApplicationController
  respond_to :html, :json, :xml

  def index
    #@tasks = current_user.tasks
    @tasks = current_user.tasks
    @groups = current_user.groups
    respond_with(@tasks)
  end

  def show
    @task = Task.find(params[:id])
    respond_with(@task)
  end

  def new
    if params[:task_id] && params[:user_id]
      task_id = params[:task_id].to_i
      user_id = params[:user_id].to_i
      user = User.find(user_id)
      task_definition = Task.find(task_id)
      if user.can_access_task_definition?(task_definition)
        @task = task_definition.create_task
        @task.owner = user
      else
        flash[:error] = I18n.translate('app.access_denied')
        redirect_to :root
      end
    else
      @task = Task.new(:owner => current_user)
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      if params[:done] then
        work_flower = WorkFlower.new
        work_flower.set_task_state(@task, current_user, :done)
      end
      respond_with do |format|
        format.html { redirect_to task_path(@task.id) }
        format.json { head :ok }
      end
    else
      respond_with do |format|
        format.html { render :edit }
        format.json { render :json => {"error" => "unable to save task", "errors" => @task.errors } }
      end
    end
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
        work_flower = WorkFlower.new
        work_flower.set_task_state(@task, current_user, :in_progress)
      respond_with do |format|
        format.html { redirect_to task_path(@task.id) }
        format.json { head :ok }
      end
    else
      respond_with do |format|
        format.html { render :new }
        format.json { render :json => {"error" => "unable to create task", "errors" => @task.errors } }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end
end

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
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
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

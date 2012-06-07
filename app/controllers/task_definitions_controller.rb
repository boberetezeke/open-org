class TaskDefinitionsController < ApplicationController
  # GET /task_definitions
  # GET /task_definitions.json
  def index
    @task_definitions = TaskDefinition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @task_definitions }
    end
  end

  # GET /task_definitions/1
  # GET /task_definitions/1.json
  def show
    @task_definition = TaskDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task_definition }
    end
  end

  # GET /task_definitions/new
  # GET /task_definitions/new.json
  def new
    @task_definition = TaskDefinition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task_definition }
    end
  end

  # GET /task_definitions/1/edit
  def edit
    @task_definition = TaskDefinition.find(params[:id])
  end

  # POST /task_definitions
  # POST /task_definitions.json
  def create
    @task_definition = TaskDefinition.new(params[:task_definition])

    respond_to do |format|
      if @task_definition.save
        format.html { redirect_to @task_definition, notice: 'Task definition was successfully created.' }
        format.json { render json: @task_definition, status: :created, location: @task_definition }
      else
        format.html { render action: "new" }
        format.json { render json: @task_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /task_definitions/1
  # PUT /task_definitions/1.json
  def update
    @task_definition = TaskDefinition.find(params[:id])

    respond_to do |format|
      if @task_definition.update_attributes(params[:task_definition])
        format.html { redirect_to @task_definition, notice: 'Task definition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_definitions/1
  # DELETE /task_definitions/1.json
  def destroy
    @task_definition = TaskDefinition.find(params[:id])
    @task_definition.destroy

    respond_to do |format|
      format.html { redirect_to task_definitions_url }
      format.json { head :no_content }
    end
  end
end

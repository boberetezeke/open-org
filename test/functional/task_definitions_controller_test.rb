require 'test_helper'

class TaskDefinitionsControllerTest < ActionController::TestCase
  setup do
    @task_definition = task_definitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_definition" do
    assert_difference('TaskDefinition.count') do
      post :create, task_definition: @task_definition.attributes
    end

    assert_redirected_to task_definition_path(assigns(:task_definition))
  end

  test "should show task_definition" do
    get :show, id: @task_definition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_definition
    assert_response :success
  end

  test "should update task_definition" do
    put :update, id: @task_definition, task_definition: @task_definition.attributes
    assert_redirected_to task_definition_path(assigns(:task_definition))
  end

  test "should destroy task_definition" do
    assert_difference('TaskDefinition.count', -1) do
      delete :destroy, id: @task_definition
    end

    assert_redirected_to task_definitions_path
  end
end

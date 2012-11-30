require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  
  setup do
    @schedule_meeting_prototype = FactoryGirl.create(:schedule_meeting)
    @jane = @schedule_meeting_prototype.role.users.first
    @bobby = FactoryGirl.create(:bobby)
    set_current_user(@jane)
  end

  test "should allow creating of new tasks assigned to the creator" do
    get :new
    assert_response :success
    assert_equal assigns(:task).owner, @jane
  end

  test "should allow parameters on new but verify access" do
    get :new, :user_id => @jane.id, :task_id => @schedule_meeting_prototype.id
    assert_response :success
    assert_equal assigns(:task).name, "schedule_meeting"
    assert_equal assigns(:task).owner, @jane
    assert_equal assigns(:task).prototype, @schedule_meeting_prototype
  end


end

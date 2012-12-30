require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  
  setup do
    FactoryGraph.new(self).create_objects(
      :pta => {:users => [:bobby, :jane]},
      :president_role => {:users => [:jane]},
      :schedule_meeting => {:role => :president_role}
    )
    set_current_user(@jane)
  end

  test "should allow creating of new tasks assigned to the creator" do
    get :new, :organization_id => @pta
    assert_response :success
    assert_equal assigns(:task).owner, @jane
  end

  test "should allow parameters on new but verify access" do
    get :new, :user_id => @jane.id, :task_id => @schedule_meeting.id, :organization_id => @pta
    assert_response :success
    assert_equal assigns(:task).name, "schedule_meeting"
    assert_equal assigns(:task).owner, @jane
    assert_equal assigns(:task).prototype, @schedule_meeting
  end


end

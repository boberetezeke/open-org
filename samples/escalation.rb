=begin
issue
  waiting_on_customer
  waiting_on_escalation
  waiting_on_engineering
  in_tech_support
  request_escaltion
  in_escalation
  request_engineering_escalation
  in_engineering
    create bug(s)
    create feature(s)

bug
  wont_fix
  in_progress
  fixed
  queued_for_release

feature
  wont_implement
  in_progress
  implemented
    request_documentation
  queued_for_release

documentation
  in_progress
  completed

release
  in_testing
  request_fixes
  in_engineering
  in_engineering_support_for_posting
=end

class EscalationTask < Task
  
end

=begin
issue view:
  customer info
  description
  [notes]
  if state == in tech suport
    -escalate to escalation- (state -> request_escalation)
  elsif state == in escalation
    -escalate to engineering- (state -> request_engineering_escalation)
  elsif state == request_escalation
    -accept escalation- (state -> in_escalation)
    -reject escalation- (with message) (state -> in_tech_support)
  elsif state == request_engineering_escalation
    -accept escalation-
    -reject escalation- (with message) 
  end

issue controller:
  update:

task_group do 
  task :issue do
    initial_state :in_tech_support

    state :in_tech_support
      performed_by :tech_support
      on_event :escalate => :request_escalation
      on_event :resolve => :completed
      on_event :request_feature => :completed
    end

    state :request_escalation
      performed_by :escalation
      on_event :rejected => :in_tech_support
      on_event :accepted => :in_escalation
    end

    state :in_escalation, :escalate => :request_engineering, :descalate => :in_tech_support, :duplicate_bug => :completed do
      performed_by :escalation
    end

    state :request_engineering :reject => :in_escalation, :accept => :in_engineering do
      performed_by :engineering
    end

    state :in_engineering, :duplicate_bug => :completed do
      performed_by :engineering
    end
  end
end
=end
  
class IssueTask
  
  on_state_change(:in_tech_support, :resolved) do
  end

  on_state_change(:in_tech_support, :requested_feature) do
    # find feature or create feature
  end

  on_enter_state(:completed) do
    
  end
end

  

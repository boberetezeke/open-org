FactoryGirl.define do
  factory :pta, class: Organization do
    name "PTA"
  end

  factory :schedule_meeting, class: Task do
    name "schedule_meeting"
    is_prototype true
  end

  factory :name_election_task_definition, class: Task do
    name "name_election_task_definition"
    is_prototype true
  end

  factory :name_election_task, class: Task do
    name "name_election_task"
    is_prototype false
  end

  factory :election_name_task_field, class: TaskField do
    name "election_name"
    data_type "string"
    control_type "text_field"
  end

  factory :election_name_task_field_value, class: TaskFieldValue do
  end
  
  factory :select_nominating_committee_task_definition, class: Task do
    name "select_nominating_committee"
    is_prototype true
  end

  factory :select_presidential_nominees_task_definition, class: Task do
    name "select_presidential_nominees"
    is_prototype true
  end

  factory :notify_membership_of_election_task_definition, class: Task do
    name "notify_membership_of_election"
    is_prototype true
  end

  factory :vote_for_officers, class: Task do
    name "select_presidential_nominees"
    is_prototype true
  end

  factory :user do
    password "asdf"
    password_confirmation "asdf"

    factory :fred, class: User do
      name "Fred"
    end

    factory :jane, class: User do
      name "Jane"
    end

    factory :sally, class: User do
      name "Sally"
    end

    factory :bobby, class: User do
      name "Bobby"
    end
  end

  factory :board, class: Group do
    name "Board"
  end

  factory :nominating_committee, class: Group do
    name "Nominating Committee"
  end

  factory :board_role, class: Role do
    name "Board Role"
  end

  factory :president_role, class: Role do
    name "President"
  end

  factory :nominating_committee_role, class: Role do
    name "Nominating Committee Role"
  end

  factory :member_role, class: Role do
    name "Member Role"
  end
end
    

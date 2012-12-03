FactoryGirl.define do
  factory :pta, class: Organization do
    name "PTA"
  end

  factory :schedule_meeting, class: Task do
    name "schedule_meeting"
    is_prototype true
    association :role, factory: :president_role
  end

  factory :select_nominating_committee_task_definition, class: Task do
    name "select_nominating_committee"
    is_prototype true
    association :role, factory: :board_role
  end

  factory :select_presidential_nominees_task_definition, class: Task do
    name "select_presidential_nominees"
    is_prototype true
    association :role, factory: :nominating_committee_role
  end

  factory :user do
    password "asdf"
    password_confirmation "asdf"

    factory :fred, class: User do
      name "Fred"
    end

    factory :jane, class: User do
      name "Jane"
      after(:create) do |user|
        user.roles << FactoryGirl.create(:members)
      end
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
    after(:create) do |group|
      group.users << [:fred, :jane, :sally].map{|name| FactoryGirl.create(name)}
    end
  end

  factory :nominating_committee, class: Group do
    name "Nominating Committee"
    after(:create) do |group|
      group.users << [:jane, :bobby].map{|name| FactoryGirl.create(name)}
    end
  end

  factory :board_role, class: Role do
    name "Board Role"
    after(:create) do |role|
      role.groups << FactoryGirl.create(:board)
    end
  end

  factory :president_role, class: Role do
    name "President"
    after(:create) do |role|
      role.users << FactoryGirl.build(:jane)
    end
  end

  factory :nominating_committee_role, class: Role do
    name "Nominating Committee Role"
    after(:create) do |role|
      role.groups << FactoryGirl.build(:nominating_committee)
    end
  end

  factory :member_role, class: Role do
    name "Member Role"
    after(:create) do |role|
      role.groups << [:fred, :jane, :sally, :bobby].map{|name| FactoryGirl.build(name)}
    end
  end
end
    

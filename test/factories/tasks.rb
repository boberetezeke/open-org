FactoryGirl.define do
  factory :org, class: Organization do
    name "org"
  end

  factory :user_role, class: Role do
    name "user_role"
  end

  factory :group_role, class: Role do
    name "group_role"
  end

  factory :user1, class: User do
    name "user1"
    password "asdf"
    password_confirmation "asdf"
  end

  factory :user2, class: User do
    name "user2"
    password "asdf"
    password_confirmation "asdf"
  end

  factory :empty_group, class: Group do
    name "empty_group"
  end

  factory :all_users_group, class: Group do
    name "all_users_group"
  end

  factory :some_users_group, class: Group do
    name "some_users_group"
  end

  factory :root_task_def, class: Task do
    name "root_task_def"
    is_prototype true
  end

  factory :mid_task_def_1, class: Task do
    name "mid_task_def_1"
    is_prototype true
  end

  factory :mid_task_def_2, class: Task do
    name "mid_task_def_2"
    is_prototype true
  end

  factory :end_task_def, class: Task do
    name "end_task_def"
    is_prototype true
  end
end


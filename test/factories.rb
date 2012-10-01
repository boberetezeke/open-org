FactoryGirl.define do
  factory :fred, class: User do
    name "Fred"
    association :board
  end

  factory :jane, class: User do
    name "Jane"
    association :board
  end

  factory :sally, class: User do
    name "Sally"
    association :board
  end

  factory :board, class: Group do
    name "Board"
  end

  factory :board_role, class: Role do
    name "Board Role"
    after(:create) do |role|
      role.groups << FactoryGirl.build(:board)
    end
  end
end
    

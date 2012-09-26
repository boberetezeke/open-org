FactoryGirl.define do
  factory :fred, class: Person do
    name "Fred"
    association :board
  end

  factory :jane, class: Person do
    name "Jane"
    association :board
  end

  factory :sally, class: Person do
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
    

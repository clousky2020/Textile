FactoryBot.define do
  factory :setting do
    sequence(:name) {|n| "设定名#{n}"}
    sequence(:description) {|n| "设定描述#{n}"}
    status {false}

  end


end
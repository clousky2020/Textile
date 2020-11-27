FactoryBot.define do
  factory :comment do
    # sequence(:content) {|n| "测试#{n}号内容"}
    content {Faker::Nation.nationality}

  end


end
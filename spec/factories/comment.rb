FactoryBot.define do
  factory :comment do
    sequence(:content) {|n| "测试#{n}号内容"}
    # association :user

  end


end
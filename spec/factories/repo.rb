FactoryBot.define do
  factory :repo do
    sequence(:name) {|n| "本厂#{n}号"}
    sequence(:address) {|n| "测试路#{n}号"}
    sequence(:description) {|n| "描述#{n}"}

  end


end
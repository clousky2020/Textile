FactoryBot.define do
  factory :sale_customer do
    sequence(:name) {|n| "test_name#{n}"}
  end
end
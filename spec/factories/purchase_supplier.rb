FactoryBot.define do
  factory :purchase_supplier do
    sequence(:name) {|n| "#{n}test_name"}

  end
end
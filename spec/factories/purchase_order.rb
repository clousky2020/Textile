FactoryBot.define do
  factory :purchase_order do
    batch_number {"测试用批号"}
    description {"测试用描述"}
    number {rand(1..100)}
    measuring_unit {"件"}
    weight {rand(1..100)}
    deposit {rand(1..100)}
    price {rand(1..10)}
    tax_rate {rand()/100}
    bill_time {rand(1..99).day.ago}
    association :user
    association :purchase_supplier
    association :repo
    association :material
  end
end
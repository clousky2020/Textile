FactoryBot.define do
  factory :sale_order do
    description {"测试用"}
    weight {rand(1..100)}
    number {rand(1..100)}
    price {rand(1..10)}
    tax_rate {rand() / 100}
    measuring_unit {"匹"}
    bill_time {rand(1..99).day.ago}
  end
end
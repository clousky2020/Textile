FactoryBot.define do
  factory :sale_order do
    sequence(:description) {|n| "描述#{n}"}
    sequence(:number) {|n| "#{n}"}
    sequence(:weight) {|n| "#{n}"}
    sequence(:price) {|n| "#{n}"}
    sequence(:tax_rate) {|n| "#{n / 100}"}
    measuring_unit {"匹"}
    bill_time {1.day.ago}
  end
end
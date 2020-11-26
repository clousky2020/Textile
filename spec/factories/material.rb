FactoryBot.define do
  factory :material do
    sequence(:name) {|n| "name#{n}"}
    sequence(:specification) {|n| "120-#{n}"}
    description {"描述"}
    measuring_unit {"件"}
    # association :purchase_supplier, factory: :purchase_order, strategy: :build
  end


end
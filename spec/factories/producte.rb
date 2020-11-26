FactoryBot.define do
  factory :product do
    name {"测试用品名"}
    description {"测试用描述"}
    specification {"测试用规格"}
    measuring_unit{"匹"}
    labor_cost{rand(30..45)}


    factory :product_random do
      sequence(:name) {|n| "品名#{n}"}
      sequence(:description) {|n| "描述#{n}"}
      sequence(:specification) {|n| "规格型号#{n}"}
      measuring_unit{"匹"}
      labor_cost{rand(30..45)}
    end


  end


end
FactoryBot.define do
  factory :material do
    name {Faker::Name.name[1..10]}
    sequence(:specification) {|n| "#{Faker::Number.number}-#{n}"}
    description {"描述"}
    measuring_unit {"件"}
  end


end
FactoryBot.define do
  factory :machine do
    specification{Faker::Name.name}
    company{Faker::Company.name}
    machine_id{rand(1..27)}
    remark{Faker::Name.name}
  end
end

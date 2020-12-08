FactoryBot.define do
  factory :machine do
    specification {Faker::Name.name}
    company {Faker::Company.name}
    sequence(:machine_id) {|n| n}
    remark {Faker::Name.name}
  end
end

FactoryBot.define do
  factory :sale_customer do
    # sequence(:name) {|n| "#{n}#{Faker::Company.name}"}
    name {Faker::Company.name}
  end
end
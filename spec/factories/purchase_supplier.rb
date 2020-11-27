FactoryBot.define do
  factory :purchase_supplier do
    sequence(:name) {|n| "#{n}#{Faker::Company.name}"}

  end
end
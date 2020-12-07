FactoryBot.define do
  factory :output do
    output_date {1.minute.ago}
    weight {rand(10..999)/10}
    association :product
    association :employee
    association :user
  end
end

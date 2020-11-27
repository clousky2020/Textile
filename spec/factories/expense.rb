FactoryBot.define do
  factory :expense do
    counterparty {Faker::Name.name[1..10]}
    expense_type {Faker::Name.name[1..5]}
    paper_amount {100}
    actual_amount {100}
    account_from {"银行"}
    bill_time {rand(1..99).days.ago}
  end


end
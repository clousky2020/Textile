FactoryBot.define do
  factory :proceed do
    paper_amount {rand(999)}
    actual_amount {rand(999)}
    account_from {"银行"}
    bill_time {rand(99).days.ago}
    association :sale_customer
    association :user
  end


end
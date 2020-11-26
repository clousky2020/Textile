FactoryBot.define do
  factory :proceed do
    association :sale_customer
    association :user
    paper_amount {100}
    actual_amount {100}
    account_from {"银行"}
    bill_time {10.minute.ago}
  end


end
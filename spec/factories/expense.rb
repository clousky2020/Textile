FactoryBot.define do
  factory :expense do
    # sequence(counterparty) {|n| "测试交易方#{n}"}
    # expense_type {"测试用类型"}
    expense_type {Faker::Name}
    paper_amount {100}
    actual_amount {100}
    account_from {"银行"}
    bill_time {10.minute.ago}
  end


end
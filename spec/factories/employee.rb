FactoryBot.define do
  factory :employee do
    name {Faker::Name.name[1..10]}
    gender {["男", "女"].sample}
    work_type {["挡车工", "其他员工"].sample}
    work_id {rand(1..10)}
    basic_wage {rand(2000.10000)}
    minimun_wage {rand(2000.10000)}
    house_allowance {rand(100)}
    other_allowance {rand(100)}
    entry_date {1.day.ago}
    phone {rand(11111111111..99999999999).to_s}
    bank_card {Faker::Bank.account_number(digits: 19)}
    id_number {Faker::IDNumber.valid_south_african_id_number}


    factory :employees do
      sequence(:work_id) {|n| n}
    end
  end


end
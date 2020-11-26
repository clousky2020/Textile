FactoryBot.define do
  factory :user do
    id {1}
    name {"测试用户"}
    email {"123456@qq.com"}
    password {"123456"}

    factory :lock_user do

      name {'锁住的用户'}
      email {'123331@qq.com'}
      password {"123456"}
      is_lock {true}
    end
    factory :user_random do
      sequence(:id) {|n| "#{n + 1}"}
      sequence(:name) {|n| "User#{n}"}
      sequence(:email) {|n| "email#{n}@qq.com"}
      password {"123456"}
    end
  end


end
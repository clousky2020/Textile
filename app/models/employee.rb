class Employee < ApplicationRecord
  has_one :user

  validates :gender, presence: true
  validates :name, length: {maximum: 10, too_long: "员工姓名过长,最多10个字符",
                            minimum: 1, too_short: "姓名过短，至少1个字符"}
  validates :work_id, uniqueness: {scope: :work_status, :message => "该工号已经被使用，请更换别的工号！"}
  # validates :phone, numericality: true, length: {is: 11, message: "手机号码位数应为11位"}
  # validates :bank_card, numericality: true, length: {is: 19, message: "银行卡号位数应为19位"}
  validates :entry_date, :presence => true

end

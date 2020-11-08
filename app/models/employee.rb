class Employee < ApplicationRecord


  validates :gender, :work_type, presence: true
  validates :name, length: {maximum: 10, too_long: "员工姓名过长,最多10个字符",
                            minimum: 1, too_short: "姓名过短，至少1个字符"}
  validates :work_id, uniqueness: {scope: :work_status, :message => "该工号已经被使用，请更换别的工号！"},
            presence: true
  validates :phone, numericality: true, length: {is: 11, message: "位数应为11位"}, allow_blank: true
  validates :bank_card, numericality: true, length: {is: 19, message: "位数应为19位"}, allow_blank: true
  validates :entry_date, :presence => true

end

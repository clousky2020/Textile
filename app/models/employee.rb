class Employee < ApplicationRecord
  has_many :outputs

  validates :gender, :work_type, presence: true
  validates :name, length: {maximum: 10, too_long: "过长,最多10个字符",
                            minimum: 1, too_short: "过短，至少1个字符"}
  validates :work_id, uniqueness: {scope: :status, :message => "已经被使用，请更换别的工号！"},
            presence: true
  validates :phone, numericality: true, length: {is: 11, message: "位数应为11位"}, allow_blank: true
  validates :bank_card, numericality: true, length: {is: 19, message: "位数应为19位"}, allow_blank: true
  validates :entry_date, presence: true

  after_create :update_status
  after_update :update_status

  def self.search(search)
    if search
      where("name LIKE :term or status LIKE :term or gender LIKE :term or work_type LIKE :term ", term: "%#{search}%")
    else
      all
    end
  end

  def update_status
    if self.daparture_date
      self.update_columns(status: false)
    else
      self.update_columns(status: true)
    end
  end

  # 查找在时间段内的使用该工号的员工
  def self.find_work_id(date, work_id)
    date = date.to_date
    employees = self.where(work_id: work_id)
    employees.each do |employee|
      employee.daparture_date = Time.now unless employee.daparture_date
      if date.between?(employee.entry_date, employee.daparture_date)
        return employee
      end
    end
    # 如果一个员工之前离职了，后来又入职，入职时间就会被刷新，将查不到先前的生产记录，这时候就返回一个最后入职的员工信息
    return employees.order("entry_date").last
  end

  def set_employee
    Output.all.each do |a|
      unless a.employee
        a.destroy
      end
    end
  end

end

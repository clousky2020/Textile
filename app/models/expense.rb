class Expense < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :purchase_suppliers

  validates :order_id, uniqueness: true
  validates :bill_time, uniqueness: {scope: [:counterparty, :paper_amount, :expense_type]}
  validates :counterparty, :expense_type, :paper_amount, :actual_amount, presence: true
  validates :paper_amount, :actual_amount, numericality: {greater_than: 0}

  mount_uploader :picture, PictureUploader

  after_create :check_result_initial
  after_create :created_person
  after_create :generate_order_id
  after_create :build_purchase_supplier

  def self.search(search)
    if search
      where("purchase_suppliers.name LIKE :term or order_id LIKE :term or counterparty LIKE :term or remark LIKE :term or expense_type LIKE :term ", term: "%#{search}%")
    else
      all
    end
  end

  #查找expense_type的值
  def self.search_expense_type(term)
    where('expense_type LIKE ?', "%#{term.strip}%")
  end

  # 如果是已经存在的供货商，则建立联系
  def build_purchase_supplier
    purchase_supplier = PurchaseSupplier.find_by_name(self.counterparty.strip)
    if purchase_supplier
      if self.purchase_suppliers.blank?
        self.purchase_suppliers << purchase_supplier
      end
    else
      self.purchase_suppliers.clear
    end
  end

  # 判断订单类型，进行加减法运算
  def calcu_to_purchase_supplier
    if self.is_invalid
      self.reduce_to_purchase_supplier
    else
      self.add_to_purchase_supplier
    end
  end

  # 订单的金额加入供货商的数据中
  def add_to_purchase_supplier
    purchase_supplier = self.purchase_suppliers[0]
    if !purchase_supplier.check_money_time || self.bill_time > purchase_supplier.check_money_time
      # 已付款
      purchase_supplier.paid += self.paper_amount
      # 计算未付的钱
      purchase_supplier.calcu_unpaid
      purchase_supplier.save
    end
  end

  # 从供货商的数据中减去相关的金额
  def reduce_to_purchase_supplier
    purchase_supplier = self.purchase_suppliers[0]
    if !purchase_supplier.check_money_time || self.bill_time > purchase_supplier.check_money_time
      # 已付款
      purchase_supplier.paid -= self.paper_amount
      # 计算未付的钱
      purchase_supplier.calcu_unpaid
      purchase_supplier.save
    end
  end

  # 图表得到支出
  def self.check_ratio(start_date, end_date)
    expenses = self.where(bill_time: start_date..end_date, is_invalid: false, check_status: true)
    h = Hash.new
    expenses.each do |expense|
      if h.has_key? expense.expense_type
        h[expense.expense_type] += expense.actual_amount
      else
        h.store(expense.expense_type, expense.actual_amount)
      end
    end
    h
  end

end

class Proceed < ApplicationRecord
  belongs_to :sale_customer
  belongs_to :user

  mount_uploader :picture, PictureUploader
  validates :order_id, uniqueness: true
  validates :bill_time, uniqueness: {scope: [:sale_customer_id, :paper_amount]}

  validates :paper_amount, :actual_amount, numericality: {greater_than: 0}

  after_create :check_result_initial
  after_create :created_person
  after_create :generate_order_id


  def self.sale_customer_search(search)
    if search
      where("sale_customers.name LIKE :term or remark LIKE :term or order_id LIKE :term", term: "%#{search}%")
    else
      all
    end
  end

  # 判断订单类型，进行加减法运算
  def calcu_to_sale_customer
    if self.is_invalid
      self.reduce_to_sale_customer
    else
      self.add_to_sale_customer
    end
  end

  # 订单的金额加入客户的数据中
  def add_to_sale_customer
    sale_customer = self.sale_customer
    if !sale_customer.check_money_time || self.bill_time > sale_customer.check_money_time
      # 已收款
      sale_customer.received += self.paper_amount
      # 计算未付的钱
      sale_customer.calcu_unreceived
      sale_customer.save
    end
  end

  # 从客户的数据中减去相关的金额
  def reduce_to_sale_customer
    sale_customer = self.sale_customer
    if !sale_customer.check_money_time || self.bill_time > sale_customer.check_money_time
      # 已收款
      sale_customer.received -= self.paper_amount
      # 计算未付的钱
      sale_customer.calcu_unreceived
      sale_customer.save
    end
  end
  
end

class SaleOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :sale_customer
  belongs_to :product

  mount_uploader :picture, PictureUploader
  validates :order_id, uniqueness: true
  validates :bill_time, uniqueness: {scope: [:sale_customer_id, :weight, :price]}
  validates :bill_time, presence: true
  validates :weight, :number, :price, numericality: {greater_than: 0}


  after_create :generate_order_id
  after_create :created_person
  after_create :calcuate_total_price
  after_create :check_result_initial
  after_update :calcuate_total_price


  def self.sale_order_search(search)
    if search
      where("sale_customers.name LIKE :term or order_id LIKE :term or products.name LIKE :term or products.specification LIKE :term",
            term: "%#{search}%")
    else
      all
    end
  end

  # 判断订单类型，进行加减法运算
  def calcu_sale_customer
    if self.is_return
      if self.is_invalid
        self.add_to_sale_customer
      else
        self.reduce_to_sale_customer
      end
    else
      if self.is_invalid
        self.reduce_to_sale_customer
      else
        self.add_to_sale_customer
      end
    end
  end


  # 订单的金额加入客户的数据中
  def add_to_sale_customer
    sale_customer = self.sale_customer
    if !sale_customer.check_money_time || self.bill_time > sale_customer.check_money_time
      sale_customer.total_collection_required += self.total_price
      # 如果还有包含的运费
      if self.freight.to_i > 0 && !self.our_freight
        sale_customer.total_collection_required += self.freight
      end
      # 计算未付的钱
      sale_customer.calcu_unreceived
      sale_customer.save
    end
  end

  # 从客户的数据中减去相关的金额
  def reduce_to_sale_customer
    sale_customer = self.sale_customer
    if !sale_customer.check_money_time || self.bill_time > sale_customer.check_money_time
      sale_customer.total_collection_required -= self.total_price
      # 如果还有包含的运费
      if self.freight.to_i > 0 && !self.our_freight
        sale_customer.total_collection_required -= self.freight
      end
      # 计算未付的钱
      sale_customer.calcu_unreceived
      sale_customer.save
    end
  end

end

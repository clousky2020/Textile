class SaleCustomer < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :products, through: :sale_orders
  has_many :proceeds

  validates :name, uniqueness: true, presence: true

  after_update :calcu_unreceived

  # 从销售单里计算总共需要付款,需要减去退货单的
  def calcu_total_collection_required
    if self.check_money_time && self.check_money
      check_money_time = self.check_money_time
      self.total_collection_required = self.sale_orders.where(check_status: true, is_invalid: false, is_return: false).
          where("bill_time> ?", check_money_time).collect(&:total_price).sum
      -self.sale_orders.where(check_status: true, is_invalid: false, is_return: true).
          where("bill_time> ?", check_money_time).collect(&:total_price).sum
    else
      self.total_collection_required = self.sale_orders.
          where(check_status: true, is_invalid: false, is_return: false).collect(&:total_price).sum
      -self.sale_orders.where(check_status: true, is_invalid: false, is_return: true).collect(&:total_price).sum
    end
    self.save
  end

  # 从收入单里计算总共已收的款(账面款)
  def calcu_received
    if self.check_money_time && self.check_money
      check_money_time = self.check_money_time
      self.received = self.proceeds.where("bill_time>?", check_money_time).where(check_status: true, is_invalid: false, is_return: false).collect(&:paper_amount).sum
    else
      self.received = self.proceeds.where(check_status: true, is_invalid: false, is_return: false).collect(&:paper_amount).sum
    end
    self.save
  end

  # 计算未付的款
  def calcu_unreceived
    if self.total_collection_required && self.received
      self.update_columns(uncollected: self.total_collection_required - self.received)
    end
  end

end

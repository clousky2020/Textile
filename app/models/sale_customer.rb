class SaleCustomer < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :products, through: :sale_orders
  has_many :proceeds

  validates :name, uniqueness: true, presence: true

  after_update :calcu_unreceived

  # 从销售单里计算总共需要付款,需要减去退货单的
  def calcu_total_collection_required
    # 得到已经审核并且没有作废的订单
    sale_orders = self.sale_orders.where(check_status: true, is_invalid: false)
    # 客户如果存在清算设定
    if self.check_money_time && self.check_money
      # 得到清算时间后的订单
      sale_orders = sale_orders.where("bill_time> ?", self.check_money_time)
      # 计算正常订单需要支付的钱款,加上设定的清算金额
      need_collection_money = sale_orders.where(is_return: false).collect(&:total_price).sum + self.check_money
      # 再加包含运费的单子里的运费
      need_collection_money += sale_orders.where(our_freight: false).collect(&:freight).sum
    else
      # 计算正常订单需要支付的钱款
      need_collection_money = sale_orders.where(is_return: false).collect(&:total_price).sum
      # 再加包含运费的单子里的运费
      need_collection_money += sale_orders.where(our_freight: false).collect(&:freight).sum
    end
    # 计算退货订单需要收回的钱款
    is_return_money = sale_orders.where(is_return: true).collect(&:total_price).sum
    is_return_money += sale_orders.where(is_return: true, our_freight: false).collect(&:freight).sum

    self.total_collection_required = need_collection_money - is_return_money
    self.save
  end

  # 从收入单里计算总共已收的款(账面款)
  def calcu_received
    # 得到已经通过审核且未作废的收款单
    proceeds = self.proceeds.where(check_status: true, is_invalid: false)
    # 根据是否定义了清算日期分别计算现在已经收回的钱款
    if self.check_money_time && self.check_money
      # 计算设定清算日期后的已收款总值
      self.received = proceeds.where("bill_time>?", self.check_money_time).collect(&:paper_amount).sum
    else
      # 计算已收款总值
      self.received = proceeds.collect(&:paper_amount).sum
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

class PurchaseSupplier < ApplicationRecord
  has_many :materials
  has_many :purchase_orders
  has_and_belongs_to_many :expenses
  validates :name, uniqueness: true, presence: true

  # 搜索所有的订单，计算一遍
  def calcu_list
    self.calcu_total_payment_required
    self.calcu_paid
    self.calcu_unpaid
    self.calcu_deposit
  end

  # 从采购单里计算总共需要付款,需要减去退货单的
  def calcu_total_payment_required
    # 得到已经通过审核且未作废的采购单
    purchase_orders = self.purchase_orders.where(check_status: true, is_invalid: false)
    # 存在清算日期和金额的，计算日期之后的账单
    if self.check_money_time && self.check_money
      # 得到清算时间后的订单
      purchase_orders = purchase_orders.where("bill_time > ?", self.check_money_time)
      # 计算应付的钱，非退货单加上设定的清算金额
      need_pay_money = purchase_orders.where(is_return: false).collect(&:total_price).sum + self.check_money
      # 再加包含运费的单子里的运费
      need_pay_money += purchase_orders.where(is_return: false, our_freight: false).where.not(freight: nil).map(&:freight).sum
    else
      # 计算得到所有非退货单的总值
      need_pay_money = purchase_orders.where(is_return: false).collect(&:total_price).sum
      # 再加包含运费的单子里的运费
      need_pay_money += purchase_orders.where(is_return: false, our_freight: false).where.not(freight: nil).map(&:freight).sum
    end
    # 计算得到退货单的总值
    is_return_money = purchase_orders.where(is_return: true).collect(&:total_price).sum
    is_return_money += purchase_orders.where(is_return: true, our_freight: false).where.not(freight: nil).map(&:freight).sum
    # 更新
    self.total_payment_required = need_pay_money - is_return_money
    self.save
  end

  # 从支出单里计算总共已付的款(账面款)
  def calcu_paid
    # 得到已经通过审核且未作废的采购单
    expenses = self.expenses.where(check_status: true, is_invalid: false)
    # 存在清算日期和金额的，计算日期之后的账单
    if self.check_money_time && self.check_money
      # 计算清算日期后的所有付款单的总值
      self.paid = expenses.where("created_at > ?", self.check_money_time).collect(&:paper_amount).sum
    else
      # 计算所有符合要求的付款单总值
      self.paid = expenses.collect(&:paper_amount).sum
    end
    self.save
  end

  # 计算未付的款
  def calcu_unpaid
    if self.total_payment_required && self.paid
      self.update_columns(unpaid: self.total_payment_required - self.paid)
    end
  end

  # 计算所有采购单的押金
  def calcu_deposit
    deposits = self.purchase_orders.where(check_status: true, is_invalid: false)
    # 存在清算日期和金额的，计算日期之后的账单
    if self.check_money_time && self.check_money
      # 得到清算时间后的订单
      deposits = deposits.where("bill_time > ?", self.check_money_time)
    end
    deposits = deposits.where("deposit > 0")
    # 计算得到所有非退货单的总值
    paid_deposit = deposits.where(is_return: false).map(&:deposit).sum
    # 计算退货单上的押金，就是从供应商那里收回的
    collection_deposit = deposits.where(is_return: true).map(&:deposit).sum
    # 总的押金等于付出的押金减去收回的押金，等于零机是回本，小于0就是赚，但这是不可能的
    self.total_deposit = paid_deposit - collection_deposit
    self.save
  end

  # 获取供货商的订单金额数据，做曲线显示
  def check_broken_line(start_date, end_date)
    orders = self.purchase_orders.where(bill_time: start_date..end_date, is_invalid: false, check_status: true)
    h = Hash.new
    orders.select(:bill_time, :total_price).each do |order|
      order_time = order.bill_time.strftime("%Y-%m-%d")
      if h.has_key? order_time
        h[order_time] += order.total_price
      else
        h.store(order_time, order.total_price)
      end
    end
    h
  end

  # 获取供货商的已付金额数据，做曲线显示
  def check_expenses(start_date, end_date)
    expenses = self.expenses.where(bill_time: start_date..end_date, is_invalid: false, check_status: true)
    h = Hash.new
    expenses.select(:bill_time, :paper_amount).each do |expense|
      order_time = expense.bill_time.strftime("%Y-%m-%d")
      if h.has_key? order_time
        h[order_time] += expense.paper_amount
      else
        h.store(expense.bill_time.strftime("%Y-%m-%d"), expense.paper_amount)
      end
    end
    h
  end

end

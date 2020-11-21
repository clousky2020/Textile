class PurchaseSupplier < ApplicationRecord
  has_many :materials
  has_many :purchase_orders
  has_and_belongs_to_many :expenses
  validates :name, uniqueness: true, presence: true

  after_update :calcu_unpaid

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
      need_pay_money += purchase_orders.where(our_freight: false).where("freight != ?", nil).map(&:freight).sum
    else
      # 计算得到所有非退货单的总值
      need_pay_money = purchase_orders.where(is_return: false).collect(&:total_price).sum

      # 再加包含运费的单子里的运费
      need_pay_money += purchase_orders.where(our_freight: false).where("freight != ?", nil).map(&:freight).sum
    end
    # 计算得到退货单的总值
    is_return_money = purchase_orders.where(is_return: true).collect(&:total_price).sum
    is_return_money += purchase_orders.where(is_return: true, our_freight: false).where("freight != ?", nil).map(&:freight).sum
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
    total_deposit = paid_deposit - collection_deposit
    total_deposit
  end

end

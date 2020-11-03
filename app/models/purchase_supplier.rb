class PurchaseSupplier < ApplicationRecord
  has_many :materials
  has_many :purchase_orders
  has_and_belongs_to_many :expenses
  validates :name, uniqueness: true, presence: true

  after_update :calcu_unpaid


  # 从采购单里计算总共需要付款,需要减去退货单的
  def calcu_total_payment_required
    if self.check_money_time && self.check_money
      check_money_time = self.check_money_time
      self.total_payment_required = self.purchase_orders.where(check_status: true, is_invalid: false, is_return: false).
          where("bill_time > ?", check_money_time).collect(&:total_price).sum
      -self.purchase_orders.where(check_status: true, is_invalid: false, is_return: true).
          where("bill_time > ?", check_money_time).collect(&:total_price).sum
    else
      self.total_payment_required = self.purchase_orders.where(check_status: true, is_invalid: false, is_return: false).collect(&:total_price).sum
      -self.purchase_orders.where(check_status: true, is_invalid: false, is_return: true).collect(&:total_price).sum
    end
    self.save
  end

  # 从支出单里计算总共已付的款(账面款)
  def calcu_paid
    if self.check_money_time && self.check_money
      check_money_time = self.check_money_time
      self.paid = self.expenses.where("created_at > ?", check_money_time).where(check_status: true, is_invalid: false).collect(&:paper_amount).sum
    else
      self.paid = self.expenses.where(check_status: true, is_invalid: false).collect(&:paper_amount).sum
    end
    self.save
  end

  # 计算未付的款
  def calcu_unpaid
    if self.total_payment_required && self.paid
      self.update_columns(unpaid: self.total_payment_required - self.paid)
    end
  end

end

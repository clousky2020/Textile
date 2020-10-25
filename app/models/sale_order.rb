class SaleOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :sale_customer
  has_one :product

  after_create :generate_order_id
  after_create :calcuate_total_price

  def calcuate_total_price
    if self.price && self.weight
      self.update_columns(total_price: self.price * self.weight * (1 - self.tax_rate))
    end
  end

  #根据订单的创建时间，生成订单号
  def generate_order_id
    self.update(order_id: self.created_at.strftime("%Y%m%d%H%M%S") + self.id.to_s)
  end

end

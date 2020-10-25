class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo

  belongs_to :purchase_supplier
  has_one :material
  accepts_nested_attributes_for :purchase_supplier

  validates :order_id, uniqueness: true

  after_create :generate_order_id
  after_create :calcuate_total_price
  after_create :created_person

  #根据订单的创建时间，生成订单号
  def generate_order_id
    self.update(order_id: self.created_at.strftime("%Y%m%d%H%M%S") + self.id.to_s)
  end

  def calcuate_total_price
    if self.price && self.weight
      self.update_columns(total_price: self.price * self.weight * (1 - self.tax_rate.to_i))
    end
  end

  def created_person
    self.update(create_person: User.find(self.user_id).name)
  end

  def self.search(search)
    if search
      where("order_id LIKE ? or description LIKE ?", "%#{search}%", "%#{search}%")
    else
      all
    end
  end
end

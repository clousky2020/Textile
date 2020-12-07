class Product < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :sale_customers, through: :sale_orders
  has_many :outputs

  validates :name, presence: true, uniqueness: {scope: :specification}
  validates :name, :specification, presence: true

  # after_update :calcu_outputs
  after_update :calcu_sales

  def calcu_outputs
    self.update_columns(production_num: self.outputs.size)
  end

  def calcu_sales
    self.update_columns(sale_num: self.sale_orders.map(&:number).sum)
  end

end

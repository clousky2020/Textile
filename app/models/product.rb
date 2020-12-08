class Product < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :sale_customers, through: :sale_orders
  has_many :outputs

  validates :name, presence: true, uniqueness: {scope: :specification}
  validates :name, :specification, presence: true


  after_update :calcu_sales

  # after_update :calcu_outputs
  # 已废弃，模型层使用counter_cache
  def calcu_outputs
    self.update_columns(production_num: self.outputs.size)
  end

  def calcu_sales
    self.update_columns(sale_num: self.sale_orders.map(&:number).sum)
  end

end

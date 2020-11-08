class Product < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :sale_customers, through: :sale_orders
  validates :name, presence: true, uniqueness: {scope: :specification}
  validates :name, :specification, presence: true

end

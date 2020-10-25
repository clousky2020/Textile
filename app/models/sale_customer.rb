class SaleCustomer < ApplicationRecord
  has_many :sale_orders, dependent: :destroy
  has_many :products, through: :sale_orders
  validates :name, uniqueness: true, presence: true
end

class Product < ApplicationRecord
  has_many :sale_order
  has_many :sale_customers, through: :sale_order
  validates :name, presence: true, uniqueness: {scope: :specification}
end

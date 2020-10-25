class ProductsStock < ApplicationRecord
  has_many :products
  belongs_to :repo
end

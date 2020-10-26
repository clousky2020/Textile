class PurchaseSupplier < ApplicationRecord
  has_many :materials
  has_many :purchase_orders

  validates :name, uniqueness: true, presence: true


end

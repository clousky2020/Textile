class PurchaseSupplier < ApplicationRecord
  has_many :materials
  has_many :purchase_orders, through: :materials

  validates :name, uniqueness: true, presence: true


end

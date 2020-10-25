class PurchaseSupplier < ApplicationRecord
  has_many :purchase_orders, dependent: :destroy,inverse_of: :purchase_supplier
  has_many :materials, through: :purchase_orders

  validates :name, uniqueness: true, presence: true


end

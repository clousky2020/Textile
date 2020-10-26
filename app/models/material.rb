class Material < ApplicationRecord
  belongs_to :purchase_supplier
  has_many :purchase_orders

  validates :name, presence: true, uniqueness: {scope: :specification}

end

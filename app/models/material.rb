class Material < ApplicationRecord
  belongs_to :purchase_order
  belongs_to :purchase_supplier


  validates :name, presence: true, uniqueness: {scope: [:specification, :batch_number]}

end

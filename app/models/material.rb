class Material < ApplicationRecord
  belongs_to :purchase_supplier
  has_many :purchase_orders

  validates :name, presence: true, uniqueness: {scope: :specification}
  validates :name, :specification, presence: true

  def self.search(search)
    if search
      where(" purchase_suppliers.name LIKE :term or materials.name LIKE :term or specification LIKE :term  ", term: "%#{search}%")
    else
      all
    end
  end


end

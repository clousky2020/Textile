class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :material
  belongs_to :purchase_supplier

  validates :order_id, uniqueness: true

  after_create :generate_order_id
  after_create :calcuate_total_price
  after_create :created_person
  after_update :calcuate_total_price

  def created_person
    self.update(create_person: User.find(self.user_id).name)
  end

  def self.search(search)
    if search
      where("order_id LIKE ? or description LIKE ?", "%#{search}%", "%#{search}%")
    else
      all
    end
  end
end

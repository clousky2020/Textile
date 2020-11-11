class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :material
  belongs_to :purchase_supplier
  mount_uploader :picture, PictureUploader

  validates :order_id, uniqueness: true
  validates :weight, :price, numericality: {:greater_than_or_equal_to => 0}

  after_create :generate_order_id
  after_create :calcuate_total_price
  after_create :created_person
  after_create :check_result_initial
  after_update :calcuate_total_price

  scope :is_invalid, -> {where(is_invalid: true)}
  validates :bill_time, uniqueness: {scope: [:purchase_supplier_id, :weight, :price]}
  scope :is_not_invalid, -> {where(is_invalid: false)}


  def self.purchase_suppliers_search(search)
    if search
      where("purchase_suppliers.name LIKE :term or order_id LIKE :term or batch_number LIKE :term or materials.name LIKE :term or materials.specification LIKE :term", term: "%#{search}%")
    else
      all
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end


end

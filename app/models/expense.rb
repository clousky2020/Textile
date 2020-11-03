class Expense < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :purchase_suppliers

  validates :order_id, uniqueness: true
  validates :counterparty, :expense_type, :paper_amount, :actual_amount, presence: true
  mount_uploader :picture, PictureUploader

  after_create :check_result_initial
  after_create :created_person
  after_create :generate_order_id
  after_create :build_purchase_supplier


  def self.search(search)
    if search
      where("purchase_suppliers.name LIKE :term or order_id LIKE :term or counterparty LIKE :term or remark LIKE :term ", term: "%#{search}%")
    else
      all
    end
  end

  # 如果是已经存在的供货商，则建立联系
  def build_purchase_supplier
    purchase_supplier = PurchaseSupplier.find_by_name(self.counterparty.strip)
    if purchase_supplier
      if self.purchase_suppliers.blank?
        self.purchase_suppliers << purchase_supplier
      end
    else
      self.purchase_suppliers.clear
    end
  end

end

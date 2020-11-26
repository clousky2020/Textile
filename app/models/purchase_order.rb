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

# 判断订单类型，进行加减法运算
  def calcu_purchase_supplier
    if self.is_return
      if self.is_invalid
        self.add_to_purchase_supplier
      else
        self.reduce_to_purchase_supplier
      end
    else
      if self.is_invalid
        self.reduce_to_purchase_supplier
      else
        self.add_to_purchase_supplier
      end
    end
  end

  # 订单的金额加入供货商的数据中
  def add_to_purchase_supplier
    purchase_supplier = self.purchase_supplier
    if !purchase_supplier.check_money_time || self.bill_time > purchase_supplier.check_money_time
      purchase_supplier.total_payment_required += self.total_price
      # 如果还有包含的运费
      if self.freight.to_i > 0 && !self.our_freight
        purchase_supplier.total_payment_required += self.freight
      end
      # 押金
      purchase_supplier.total_deposit += self.deposit
      # 计算未付的钱
      purchase_supplier.calcu_unpaid
      purchase_supplier.save
    end
  end

  # 从供货商的数据中减去相关的金额
  def reduce_to_purchase_supplier
    purchase_supplier = self.purchase_supplier
    if !purchase_supplier.check_money_time || self.bill_time > purchase_supplier.check_money_time
      purchase_supplier.total_payment_required -= self.total_price
      # 如果还有包含的运费
      if self.freight.to_i > 0 && !self.our_freight
        purchase_supplier.total_payment_required -= self.freight
      end
      # 押金
      purchase_supplier.total_deposit -= self.deposit
      # 计算未付的钱
      purchase_supplier.calcu_unpaid
      purchase_supplier.save
    end
  end

end

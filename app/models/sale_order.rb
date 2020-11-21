class SaleOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :sale_customer
  belongs_to :product

  mount_uploader :picture, PictureUploader
  validates :order_id, uniqueness: true
  validates :bill_time, uniqueness: {scope: [:sale_customer_id, :weight, :price]}
  validates :weight, :number, :price, numericality: {greater_than: 0}


  before_create :generate_order_id
  after_create :created_person
  after_create :calcuate_total_price
  after_create :check_result_initial
  after_update :calcuate_total_price


  def self.sale_order_search(search)
    if search
      where("sale_customers.name LIKE :term or order_id LIKE :term or products.name LIKE :term or products.specification LIKE :term",
            term: "%#{search}%")
    else
      all
    end
  end

end

class SaleOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :sale_customer
  belongs_to :product

  mount_uploader :picture, PictureUploader
  validates :order_id, uniqueness: true
  validates :weight, :price, numericality: {greater_than: 0, message: "必须大于零"}


  after_create :generate_order_id
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

  # 得到销售单的日期和金额
  def self.check_date(start_date, end_date)
    sale_orders = self.where(bill_time: start_date..end_date).select(:bill_time, :total_price)
    h = Hash.new
    sale_orders.each do |sale_order|
      bill_date = sale_order.bill_time.strftime("%Y-%m-%d")
      total_price = sale_order.total_price
      if h.has_key? bill_date
        h[bill_date] += total_price
      else
        h.store(bill_date, total_price)
      end
    end
    h
  end

end

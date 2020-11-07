class Proceed < ApplicationRecord
  belongs_to :sale_customer
  belongs_to :user

  mount_uploader :picture, PictureUploader
  validates :order_id, uniqueness: true
  validates :paper_amount, :actual_amount, numericality: {greater_than: 0}

  after_create :check_result_initial
  after_create :created_person
  after_create :generate_order_id


  def self.sale_customer_search(search)
    if search
      where("sale_customers.name LIKE :term or remark LIKE :term or order_id LIKE :term", term: "%#{search}%")
    else
      all
    end
  end

  # 得到收款的日期和金额
  def self.check_date(start_date, end_date)
    sale_orders = self.where(bill_time: start_date..end_date).select(:bill_time, :paper_amount)
    h = Hash.new
    sale_orders.each do |sale_order|
      bill_date = sale_order.bill_time.strftime("%Y-%m-%d")
      total_price = sale_order.paper_amount
      if h.has_key? bill_date
        h[bill_date] += total_price
      else
        h.store(bill_date, total_price)
      end
    end
    h
  end


end

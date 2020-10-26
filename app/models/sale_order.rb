class SaleOrder < ApplicationRecord
  belongs_to :user
  belongs_to :repo
  belongs_to :sale_customer
  belongs_to :product
  accepts_nested_attributes_for :product
  accepts_nested_attributes_for :sale_customer


  validates :order_id, uniqueness: true

  after_create :generate_order_id
  after_create :calcuate_total_price


end

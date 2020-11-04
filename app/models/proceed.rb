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

end

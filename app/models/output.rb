class Output < ApplicationRecord
  belongs_to :machine
  belongs_to :product, counter_cache: :production_num
  # belongs_to :employee, foreign_key: 'work_id'

  validates :weight, :output_date, presence: true

  after_create :output_add_to_product
  after_destroy :reduce_the_product

  def self.search(search)
    if search
      where("output_date LIKE :term or machine_id LIKE :term  or employee_id LIKE :term or weight LIKE :term or product.specification LIKE :term", term: "%#{search}%")
    else
      all
    end
  end

  def self.outputs_save(params)
    params_size = params[:record][:output_date].size
    n = 0
    while n < params_size
      output_date = params[:record]['output_date'][n]
      product_id = params[:record]['product_specification'][n]
      machine_id = params[:record]['machine_id'][n]
      work_id = params[:record]['work_id'][n]
      weight = params[:record]['weight'][n]
      self.create!(output_date: output_date, product_id: product_id, machine_id: machine_id, work_id: work_id, weight: weight)
      # self.output_add_to_product
      n += 1
    end
    return "成功创建"
  end

  def output_add_to_product
    product = Product.find(self.product_id)
    product.production_num += 1
  end

  def reduce_the_product
    product = Product.find(self.product_id)
    product.production_num -= 1
  end


end

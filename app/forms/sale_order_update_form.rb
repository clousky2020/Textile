class SaleOrderUpdateForm

  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, "SaleOrders")
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  validates :name, :specification, :measuring_unit, :number, :weight, :user_id, :repo_id, :sale_customer, :bill_time, presence: true
  validates :weight, :price, numericality: {greater_than: 0}

  def initialize(sale_order)
    @sale_order = sale_order
    @sale_customer = sale_order.sale_customer.name
    @product = @sale_order.product
    @repo = @sale_order.repo
    @user = @sale_order.user
  end

  def id
    @sale_order.id
  end

  def name
    @name ||= @product.name
  end

  def our_freight
    @our_freight ||= @sale_order.our_freight
  end

  def specification
    @specification ||= @product.specification
  end

  def description
    @description ||= @sale_order.description
  end

  def number
    @number ||= @sale_order.number
  end

  def measuring_unit
    @measuring_unit ||= @sale_order.measuring_unit
  end

  def weight
    @weight ||= @sale_order.weight
  end

  def price
    @price ||= @sale_order.price
  end

  def tax_rate
    @tax_rate ||= @sale_order.tax_rate
  end

  def freight
    @freight ||= @sale_order.freight
  end

  def picture
    @picture ||= @sale_order.picture
  end

  def is_return
    @is_return ||= @sale_order.is_return
  end

  def product_id
    @product_id ||= @sale_order.product_id
  end

  def repo_id
    @repo_id ||= @sale_order.repo_id
  end

  def user_id
    @user_id ||= @sale_order.user_id
  end

  def sale_customer
    @sale_customer ||= @sale_order.sale_customer
  end

  def bill_time
    @bill_time ||= @sale_order.bill_time
  end


  def update(params)
    @name = params[:name]
    @product_id = params[:specification]
    @description = params[:description]
    @measuring_unit = params[:measuring_unit]
    @number = params[:number]
    @weight = params[:weight]
    @price = params[:price]
    @tax_rate = params[:tax_rate]
    @freight = params[:freight]
    @repo_id = params[:repo_id]
    @user_id = params[:user_id]
    @picture = params[:picture]
    @bill_time = params[:bill_time]
    @is_return = params[:is_return]
    @sale_customer = params[:sale_customer]
    @our_freight = params[:our_freight]
    if valid?
      sale_customer = SaleCustomer.find_or_create_by(name: self.sale_customer)
      product = Product.find_by(id: @product_id)
      @sale_order.update(product_id: product.id, description: self.description, sale_customer_id: sale_customer.id,
                         measuring_unit: self.measuring_unit, repo_id: self.repo_id, user_id: self.user_id, our_freight: self.our_freight,
                         number: self.number, weight: self.weight, price: self.price, tax_rate: self.tax_rate,
                         freight: self.freight, picture: self.picture, is_return: self.is_return, bill_time: self.bill_time)
      # 如果有图片，把图片的路径保存
      if self.picture
        @sale_order.picture = self.picture
        @sale_order.save
      end
      if self.freight > 0 && self.our_freight
        Expense.find_or_create_by(counterparty: sale_customer.name, paper_amount: self.freight, actual_amount: self.freight,
                                  user_id: self.user_id, bill_time: self.bill_time, expense_type: "销售运费",
                                  remark: ("销售单#{@sale_order.order_id}的运费,产品是#{self.name}"))

      end

      true
    else
      false
    end

  end
end
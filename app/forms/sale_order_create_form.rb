class SaleOrderCreateForm
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  def self.model_name
    ActiveModel::Name.new(self, nil, "SaleOrders")
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor(:name, :specification, :description, :measuring_unit, :number, :weight, :price, :bill_time, :our_freight,
                :tax_rate, :freight, :picture, :is_return, :user_id, :repo_id, :product_id, :sale_customer)
  validates :name, :measuring_unit, :number, :weight, :user_id, :repo_id, :sale_customer, :bill_time, presence: true
  validates :weight, :price, numericality: {greater_than: 0}

  def initialize
  end

  def order_id
    @order.id ||= 0
  end

  def tax_rate
    @tax_rate ||= 0
  end

  def number
    @number ||= 0
  end

  def weight
    @weight ||= 0
  end

  def price
    @price ||= 0
  end

  def freight
    @freight ||= 0
  end


  def submit(params)
    self.name = params[:name]
    self.product_id = params[:specification]
    self.description = params[:description]
    self.measuring_unit = params[:measuring_unit]
    @number = params[:number]
    @weight = params[:weight]
    @price = params[:price]
    @tax_rate = params[:tax_rate]
    @freight = params[:freight]
    self.repo_id = params[:repo_id]
    self.user_id = params[:user_id]
    self.is_return = params[:is_return]
    self.picture = params[:picture]
    self.bill_time = params[:bill_time]
    self.sale_customer = params[:sale_customer]
    self.our_freight = params[:our_freight]
    if valid?
      sale_customer = SaleCustomer.find_or_create_by(name: self.sale_customer.strip)
      @order = SaleOrder.find_by(sale_customer_id: sale_customer.id, description: self.description.strip, bill_time: self.bill_time,
                                 measuring_unit: self.measuring_unit, product_id: self.product_id, repo_id: self.repo_id,
                                 user_id: self.user_id, number: self.number, weight: self.weight, price: self.price,
                                 tax_rate: self.tax_rate, freight: self.freight, is_return: self.is_return, our_freight: self.our_freight)
      if !@order
        @order = SaleOrder.create(sale_customer_id: sale_customer.id, description: self.description.strip, bill_time: self.bill_time,
                                  measuring_unit: self.measuring_unit, product_id: self.product_id, repo_id: self.repo_id,
                                  user_id: self.user_id, number: self.number, weight: self.weight, price: self.price,
                                  tax_rate: self.tax_rate, freight: self.freight, is_return: self.is_return, our_freight: self.our_freight)
        # 如果有图片，把图片的路径保存
        if self.picture
          @order.picture = self.picture
          @order.save
        end
        # 如果有运费且运费是我们出的，需要生成一张相关的付款单
        if self.our_freight == "1" && self.freight.to_i > 0
          Expense.create(counterparty: "运输公司", paper_amount: self.freight, actual_amount: self.freight,
                         user_id: self.user_id, bill_time: self.bill_time, expense_type: "销售运费",
                         remark: ("#{sale_customer.name}销售单#{@order.order_id}的运费,产品是#{self.name}"))

        end

      else
        flash = "已经有相同的订单了,订单号#{@order.order_id}"
        return false, flash
      end
      flash = "创建成功,订单号#{@order.order_id}"
      return true, flash
    else
      return false, ""
    end

  end
end
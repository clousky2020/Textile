class PurchaseOrderUpdateForm

  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, "PurchaseOrders")
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  validates :name, :specification, :measuring_unit, :number, :weight, :user_id, :repo_id, :bill_time, presence: true
  validates :weight, :price, numericality: {greater_than_or_equal_to: 0}

  def initialize(purchase_order)
    @purchase_order = purchase_order
    @material = @purchase_order.material
    @repo = @purchase_order.repo
    @user = @purchase_order.user
  end

  def id
    id = @purchase_order.id
  end

  def name
    @name ||= @material.name
  end

  def our_freight
    @our_freight ||= @purchase_order.our_freight
  end

  def specification
    @specification ||= @material.specification
  end

  def batch_number
    @batch_number ||= @purchase_order.batch_number
  end

  def description
    @description ||= @purchase_order.description
  end

  def number
    @number ||= @purchase_order.number
  end

  def measuring_unit
    @measuring_unit ||= @purchase_order.measuring_unit
  end

  def weight
    @weight ||= @purchase_order.weight
  end

  def price
    @price ||= @purchase_order.price
  end

  def tax_rate
    @tax_rate ||= @purchase_order.tax_rate
  end

  def deposit
    @deposit ||= @purchase_order.deposit
  end

  def freight
    @freight ||= @purchase_order.freight
  end

  def picture
    @picture ||= @purchase_order.picture
  end

  def is_return
    @is_return ||= @purchase_order.is_return
  end

  def material_id
    @material_id ||= @material.id
  end

  def repo_id
    @repo_id ||= @repo.id
  end

  def user_id
    @user_id ||= @user.id
  end

  def bill_time
    @bill_time ||= @purchase_order.bill_time
  end

  def purchase_supplier
    @purchase_supplier ||= @material.purchase_supplier.name
  end


  def update(params)
    @name = params[:name]
    @specification = params[:specification]
    @description = params[:description]
    @batch_number = params[:batch_number]
    @measuring_unit = params[:measuring_unit]
    @number = params[:number]
    @weight = params[:weight]
    @price = params[:price]
    @tax_rate = params[:tax_rate]
    @deposit = params[:deposit]
    @freight = params[:freight]
    @our_freight = params[:our_freight]
    @repo_id = params[:repo_id]
    @user_id = params[:user_id]
    @picture = params[:picture]
    @bill_time = params[:bill_time]
    @is_return = params[:is_return]
    @purchase_supplier = params[:purchase_supplier]
    if valid?
      purchase_supplier = PurchaseSupplier.find_or_create_by(name: self.purchase_supplier.strip)
      @purchase_order.material.update(name: self.name.strip, specification: self.specification.strip, purchase_supplier_id: purchase_supplier.id)
      @purchase_order.update(material_id: self.material_id, description: self.description.strip, batch_number: self.batch_number.strip,
                             measuring_unit: self.measuring_unit, repo_id: self.repo_id, user_id: self.user_id, bill_time: self.bill_time,
                             number: self.number, weight: self.weight, price: self.price, tax_rate: self.tax_rate, our_freight: self.our_freight,
                             deposit: self.deposit, freight: self.freight, picture: self.picture, is_return: self.is_return)
      if self.our_freight == '1' && self.freight.to_i > 0
        expense = Expense.find_by(counterparty: "运输公司", user_id: self.user_id, bill_time: self.bill_time, expense_type: "采购运费",is_invalid:false,
                                  remark: ("#{purchase_supplier.name}采购单#{@purchase_order.order_id}的运费,原料是#{self.name}"))
        if expense
          Expense.update(paper_amount: self.freight, actual_amount: self.freight)
        else
          Expense.create(counterparty: "运输公司", paper_amount: self.freight, actual_amount: self.freight,
                         user_id: self.user_id, bill_time: self.bill_time, expense_type: "采购运费",
                         remark: ("#{purchase_supplier.name}采购单#{@purchase_order.order_id}的运费,原料是#{self.name}"))
        end
      end
      true
    else
      false
    end

  end
end
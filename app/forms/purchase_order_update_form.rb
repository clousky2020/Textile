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

  validates :name, :specification, :measuring_unit, :number, :weight, :user_id, :repo_id, presence: true

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
    @repo_id = params[:repo_id]
    @user_id = params[:user_id]
    @picture = params[:picture]
    @is_return = params[:is_return]
    @purchase_supplier = params[:purchase_supplier]
    if valid?
      @purchase_order.material.purchase_supplier.update(name: self.purchase_supplier)
      @purchase_order.material.update(name: self.name, specification: self.specification)
      @purchase_order.update(material_id: self.material_id, description: self.description, batch_number: self.batch_number,
                             measuring_unit: self.measuring_unit, repo_id: self.repo_id, user_id: self.user_id,
                             number: self.number, weight: self.weight, price: self.price, tax_rate: self.tax_rate,
                             deposit: self.deposit, freight: self.freight, picture: self.picture, is_return: self.is_return)
      true
    else
      false
    end

  end
end
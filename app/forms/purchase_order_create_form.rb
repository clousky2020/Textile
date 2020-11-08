class PurchaseOrderCreateForm
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  def self.model_name
    ActiveModel::Name.new(self, nil, "PurchaseOrders")
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor(:name, :specification, :description, :batch_number, :measuring_unit, :number, :weight, :price, :purchase_supplier,
                :tax_rate, :deposit, :freight, :picture, :is_return, :user_id, :repo_id, :material_id, :bill_time)
  validates :name, :specification, :measuring_unit, :number, :weight, :user_id, :repo_id, :purchase_supplier, :bill_time, presence: true
  validates :weight, :price, numericality: {greater_than_or_equal_to: 0}

  def initialize
  end


  def submit(params)
    self.name = params[:name]
    self.specification = params[:specification]
    self.description = params[:description]
    self.batch_number = params[:batch_number]
    self.measuring_unit = params[:measuring_unit]
    self.number = params[:number]
    self.weight = params[:weight]
    self.price = params[:price]
    self.tax_rate = params[:tax_rate]
    self.deposit = params[:deposit]
    self.freight = params[:freight]
    self.repo_id = params[:repo_id]
    self.user_id = params[:user_id]
    self.is_return = params[:is_return]
    self.picture = params[:picture]
    self.bill_time = params[:bill_time]
    self.purchase_supplier = params[:purchase_supplier]
    if valid?
      purchase_supplier = PurchaseSupplier.find_or_create_by(name: self.purchase_supplier.strip)
      material = Material.find_or_create_by(name: self.name.strip, specification: self.specification.strip, purchase_supplier_id: purchase_supplier.id)
      @order = PurchaseOrder.find_by(purchase_supplier_id: purchase_supplier.id, description: self.description.strip, batch_number: self.batch_number.strip,
                                     measuring_unit: self.measuring_unit, material_id: material.id, repo_id: self.repo_id, bill_time: self.bill_time,
                                     user_id: self.user_id, number: self.number, weight: self.weight, price: self.price,
                                     tax_rate: self.tax_rate, deposit: self.deposit, freight: self.freight, is_return: self.is_return)
      if !@order
        @order = PurchaseOrder.create!(purchase_supplier_id: purchase_supplier.id, description: self.description.strip, batch_number: self.batch_number.strip,
                                      measuring_unit: self.measuring_unit, material_id: material.id, repo_id: self.repo_id, bill_time: self.bill_time,
                                      user_id: self.user_id, number: self.number, weight: self.weight, price: self.price,
                                      tax_rate: self.tax_rate, deposit: self.deposit, freight: self.freight, is_return: self.is_return)
        # 有图片则另外记录进去
        if @order && self.picture
          @order.picture = self.picture
          @order.save
        end

      else
        flash = "已经有相同的订单了,订单号#{@order.order_id}"
        return false, flash,@order
      end
      flash = "创建成功,订单号#{@order.order_id}"
      return true, flash,@order
    else
      return false, "",@order
    end
  end

end

class PurchaseOrderCreateForm
  include ActiveModel::Model
  include ActiveModel::Validations

  def self.model_name
    ActiveModel::Name.new(self, nil, "PurchaseOrder")
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor(:name, :specification, :description, :batch_number, :measuring_unit, :number, :weight, :price,
                :tax_rate, :deposit, :freight, :picture, :is_return, :user_id, :repo_id, :material_id, :purchase_supplier)
  validates :name, :specification, :measuring_unit, :number, :weight, :user_id, :repo_id, presence: true

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
    self.is_return = params[:is_return]
    self.purchase_supplier = params[:purchase_supplier]
    if valid?
      purchase_supplier = PurchaseSupplier.find_or_create_by(self.purchase_supplier)
      material = Material.find_or_create_by(name: self.color, specification: self.specification, purchase_supplier_id: purchase_supplier.id)
      PurchaseOrder.find_by_created_at(name: material.name, specification: material.specification, description: self.description,
                                       measuring_unit: self.measuring_unit, material_id: material.id, repo_id: self.repo_id,
                                       user_id: self.user_id, number: self.number, weight: self.weight, price: self.price,
                                       tax_rate: self.tax_rate, deposit: self.deposit, freight: self.freight, picture: self.picture,
                                       is_return: self.is_return)
      true
    else
      false
    end

  end
end
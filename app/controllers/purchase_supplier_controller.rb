class PurchaseSupplierController < ApplicationController
  before_action :get_supplier, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @suppliers = PurchaseSupplier.where("name LIKE?", "%#{params[:search]}%").order("name").page(params[:page])
    else
      @suppliers = PurchaseSupplier.order("name").page(params[:page])
    end
  end

  def new
    @suppliers = PurchaseSupplier.new
  end

  def edit

  end

  def show

  end

  def create
    @supplier = PurchaseSupplier.new(purchase_supplier_params)
    if @supplier.save
      flash[:success] = "创建成功"
      redirect_to purchase_supplier_index_path
    else
      flash[:warning] = "#{@supplier.errors.full_messages.to_s}"
      render "purchase_supplier/new"
    end
  end

  def update
    if @supplier.update(purchase_supplier_params)
      flash[:success] = "成功更新供应商信息"
      redirect_to purchase_supplier_url(@supplier)
    else
      flash[:warning] = "#{@supplier.errors.full_messages.to_s}"
      render "purchase_supplier/edit"
    end
  end

  def destroy
    if @supplier.purchase_orders.where(status: true).blank?
      PurchaseSupplier.delete(@supplier)
      flash[:warning] = "已经删除供应商#{@supplier.name}了"
      redirect_to purchase_supplier_index_path
    else
      flash[:warning] = "该供应商名下下还有订单，不能删除"
      redirect_to purchase_supplier_index_path
    end
  end

  private

  def get_supplier
    @supplier = PurchaseSupplier.find(params[:id])
  end

  def purchase_supplier_params
    params.require(:purchase_supplier).permit(:name, :contacts, :phone, :address, :description, :status)
  end

end

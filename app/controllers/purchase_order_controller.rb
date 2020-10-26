class PurchaseOrderController < ApplicationController
  before_action :get_purchase_order, only: [:show, :destroy]
  # before_action :handlers, only: [:edit, :new]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @purchase_orders = PurchaseOrder.where.not(status: false).search(params[:search]).order("created_at DESC").page(params[:page])
    elsif params.has_key?(:search_comapny) && params[:search_comapny] != ""
      @purchase_orders = PurchaseOrder.where(status: true).includes(:material).includes(:purchase_supplier).where("name=?", params[:search_comapny]).order("created_at").page(params[:page])
    elsif params[:order] == "all"
      @purchase_orders = PurchaseOrder.search(params[:search]).order("created_at DESC").page(params[:page])
    else
      @purchase_orders = PurchaseOrder.where.not(status: false).order("created_at DESC").page(params[:page])
    end
  end

  def new
    @purchase_order = PurchaseOrderCreateForm.new
  end

  def edit
    @purchase_order = PurchaseOrderUpdateForm.new(@purchase_order)
  end

  def show

  end

  def create
    @purchase_order = PurchaseOrderCreateForm.new
    params[:purchase_orders][:user_id] = current_user.id
    if @purchase_order.submit(params[:purchase_orders])
      flash[:success] = "创建成功"
      redirect_to purchase_order_index_path
    else
      flash[:warning] = "#{@purchase_order.errors.full_messages}"
      render "purchase_order/new"
    end
  end

  def update
    @purchase_order = PurchaseOrderUpdateForm.new @purchase_order
    if @purchase_order.update(params[:purchase_orders])
      flash[:success] = "成功更新供应订单信息"
      redirect_to purchase_order_url(@purchase_order.id)
    else
      flash[:warning] = "#{@purchase_order.errors.full_messages.to_s}"
      render "purchase_order/edit"
    end
  end

  def destroy
    @purchase_order.update_columns(status: false)
    flash[:success] = "#{@purchase_order.material.purchase_supplier.name}的订单#{@purchase_order.order_id}已作废"
    # PurchaseOrder.delete(@purchase_order)
    redirect_to purchase_order_index_path
  end

  private

  #得到有权限制作和修改销售订单的人
  def handlers
    @salers = User.joins(:roles).where(roles: {name: "sale"})
  end

  def get_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end


  # def purchase_order_params
  #   params.require(:purchase_order).permit(:name, :specification, :batch_number, :description, :purchase_supplier,
  #                                          :repo_id, :user_id, :number, :measuring_unit, :weight, :price, :tax_rate,
  #                                          :deposit, :freight, :picture, :is_return, :material, :purchase_supplier,
  #                                          purchase_supplier_attributes: [:id, :name],
  #                                          materials_attributes: [:id, :name, :specification])
  # end


end

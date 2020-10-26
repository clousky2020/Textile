class SaleOrderController < ApplicationController
  before_action :get_sale_order, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @sale_orders = SaleOrder.where.not(status: false).search(params[:search]).order("created_at DESC").page(params[:page])
    elsif params[:order] == "all"
      @sale_orders = SaleOrder.search(params[:search]).order("created_at DESC").page(params[:page])
    else
      @sale_orders = SaleOrder.where.not(status: false).order("created_at DESC").page(params[:page])
    end
  end

  def new
    @sale_order = SaleOrder.new
    @sale_order.build_sale_customer
    @sale_order.build_product
    @sale_order.build_user
    @sale_order.build_repo
  end

  def edit

  end

  def show

  end

  def create
    @sale_order = SaleOrder.new(sale_order_params)
    if @sale_order.save
      flash[:success] = "创建成功"
      redirect_to sale_order_index_path
    else
      flash[:warning] = "#{@sale_order.errors.full_messages}"
      render "sale_order/new"
    end
  end

  def update
    if @sale_order.update(sale_order_params)
      flash[:success] = "成功更新供应订单信息"
      redirect_to sale_order_url(@sale_order)
    else
      flash[:warning] = "#{@sale_order.errors.full_messages.to_s}"
      render "sale_order/edit"
    end
  end

  def destroy
    @sale_order.update_columns(status: false)
    flash[:success] = "#{@sale_order.sale_customer.name}的订单#{@sale_order.order_id}已作废"
    # SaleOrder.delete(@sale_order)
    redirect_to sale_order_index_path
  end

  private


  def get_sale_order
    @sale_order = SaleOrder.find(params[:id])
  end

  def sale_order_params
    params.require(:sale_order).permit(:name, :specification, :description, :repo_id, :user_id, :number, :freight,
                                       :measuring_unit, :price, :tax_rate, :deposit, :weight, :picture, :is_return,
                                       sale_customer_attributes: [:id, :name], product_attributes: [:id, :name, :specification])
  end


end

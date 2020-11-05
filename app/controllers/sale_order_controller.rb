class SaleOrderController < ApplicationController
  before_action :get_sale_order, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    # if params.has_key?(:search) && params.has_key?(:type)
    #   type = params[:type].split(":")
    #   @sale_orders = SaleOrder.includes(:sale_customer, :product).sale_order_search(params[:search]).
    #       where("#{type[0]}=?", type[1]).references(:sale_customer, :product).order("bill_time DESC").page(params[:page])
    # elsif params.has_key?(:type) && params[:type] != ""
    #   type = params[:type].split(":")
    #   @sale_orders = SaleOrder.includes(:sale_customer, :product).where(is_invalid: false).where("#{type[0]}=?", type[1]).
    #       references(:sale_customer, :product).order("check_status").page(params[:page])
    # elsif params.has_key?(:search) && params[:search] != ""
    #   @sale_orders = SaleOrder.includes(:sale_customer, :product).where(is_invalid: false).sale_order_search(params[:search]).
    #       references(:sale_customer, :product).order("check_status").page(params[:page])
    # else
    #   @sale_orders = SaleOrder.where(is_invalid: false).order("updated_at DESC").page(params[:page])
    # end
    if params.has_key?(:search) || params.has_key?(:type)
      @sale_orders = SaleOrder.includes(:sale_customer, :product).references(:sale_customer, :product)
      if params.has_key?(:search) && params[:search] != ""
        @sale_orders = @sale_orders.sale_order_search(params[:search])
      end
      if params.has_key?(:type) && params[:type] != ""
        type = params[:type].split(":")
        @sale_orders = @sale_orders.where("#{type[0]}=?", type[1])
      end
      @sale_orders = @sale_orders.page(params[:page])
    else
      @sale_orders = SaleOrder.where(is_invalid: false).order("updated_at DESC").page(params[:page])
    end
  end

  def new
    @sale_order = SaleOrderCreateForm.new
  end

  def edit
    if !@sale_order.is_invalid
      if !@sale_order.check_status
        @sale_order = SaleOrderUpdateForm.new(@sale_order)
      else
        flash[:warning] = "订单已审核，不可更改"
        render "sale_order/show"
      end
    else
      flash[:warning] = "订单已作废，不可更改"
      render "sale_order/show"
    end
  end

  def show
    store_referrer_location
  end

  def create
    @sale_order = SaleOrderCreateForm.new
    info = @sale_order.submit(params[:sale_orders])
    if info[0]
      flash[:success] = info[1]
      redirect_to sale_order_index_path
    else
      flash[:warning] = "#{(@sale_order.errors.full_messages << info[1]).join(',')}"
      render "sale_order/new"
    end
  end

  def update
    @sale_order = SaleOrderUpdateForm.new @sale_order
    if @sale_order.update(params[:sale_orders])
      flash[:success] = "成功更新供应订单信息"
      redirect_to sale_order_url(@sale_order.id)
    else
      flash[:warning] = "#{@sale_order.errors.full_messages.join(',')}"
      render "sale_order/edit"
    end
  end

  def destroy
    store_referrer_location
    @sale_order.order_declare_invalid(current_user)
    flash[:success] = "#{@sale_order.sale_customer.name}的订单#{@sale_order.order_id}已作废"
    redirect_back_referrer_for sale_order_index_path
  end

  def pass_check
    if !@sale_order.is_invalid
      @sale_order.pass_check_result(current_user)
      flash[:success] = "订单号#{@sale_order.order_id}已审核"
      redirect_back_referrer_for sale_order_path(@sale_order.id)
    else
      flash[:warning] = "订单已作废，不用审核了"
      render "sale_order/show"
    end
  end

  private


  def get_sale_order
    @sale_order = SaleOrder.find(params[:id])
  end

  # def sale_order_params
  #   params.require(:sale_order).permit(:name, :specification, :description, :repo_id, :user_id, :number, :freight,
  #                                      :measuring_unit, :price, :tax_rate, :deposit, :weight, :picture, :is_return,
  #                                      sale_customer_attributes: [:id, :name],
  #                                      product_attributes: [:id, :name, :specification])
  # end


end

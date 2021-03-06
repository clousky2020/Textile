class SaleOrdersController < ApplicationController
  before_action :get_sale_order, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) || params.has_key?(:type)
      @sale_orders = SaleOrder.includes(:sale_customer, :product).references(:sale_customers, :products)
      if params.has_key?(:search) && params[:search] != ""
        @sale_orders = @sale_orders.sale_order_search(params[:search])
      end
      if params.has_key?(:type) && params[:type] != ""
        type = params[:type].split(":")
        @sale_orders = @sale_orders.where("#{type[0]}=?", type[1])
      end
      @sale_orders = @sale_orders.page(params[:page])
    else
      @sale_orders = SaleOrder.where(is_invalid: false).order("check_status,updated_at DESC").page(params[:page])
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
        render "sale_orders/show"
      end
    else
      flash[:warning] = "订单已作废，不可更改"
      render "sale_orders/show"
    end
  end

  def show
    unless request.referrer =~ /(new|edit)/
      store_referrer_location
    end
    # @sale_order.sale_customer.calcu_total_collection_required
  end

  def create
    @sale_order = SaleOrderCreateForm.new
    info = @sale_order.submit(params[:sale_orders])
    if info[0]
      flash[:success] = info[1]
      if Setting.setting_status("销售账单自动审核") && current_user.roles.any? {|role| role.permissions.sale_orders.pass_check?}
        SaleOrder.find(@sale_order.order_id).pass_check_result(current_user)
      end
      redirect_to sale_orders_path
    else
      flash[:warning] = "#{(@sale_order.errors.full_messages << info[1]).join(',')}"
      render "sale_orders/new"
    end
  end

  def update
    @sale_order = SaleOrderUpdateForm.new @sale_order
    if @sale_order.update(params[:sale_orders])
      flash[:success] = "成功更新供应订单信息"
      redirect_to sale_order_url(@sale_order.id)
    else
      flash[:warning] = "#{@sale_order.errors.full_messages.join(',')}"
      render "sale_orders/edit"
    end
  end

  def destroy
    store_referrer_location
    if @sale_order.check_status
      @sale_order.order_declare_invalid(current_user)
      # @sale_order.sale_customer.calcu_list
      @sale_order.calcu_sale_customer
      flash[:success] = "#{@sale_order.sale_customer.name}的订单#{@sale_order.order_id}已作废"
    else
      @sale_order.destroy
      flash[:success] = "#{@sale_order.sale_customer.name}的订单#{@sale_order.order_id}已删除"
    end
    redirect_back_referrer_for sale_orders_path
  end

  def pass_check
    if !@sale_order.is_invalid
      @sale_order.pass_check_result(current_user)
      # @sale_order.sale_customer.calcu_list
      @sale_order.calcu_sale_customer
      flash[:success] = "订单号#{@sale_order.order_id}已审核"
      if Setting.setting_status("连续审核") && next_order = SaleOrder.find_by(check_status: false, sale_customer_id: @sale_order.sale_customer_id)
        redirect_to sale_order_path(next_order)
      else
        redirect_back_referrer_for sale_order_path(@sale_order.id)
      end
    else
      flash[:warning] = "订单已作废，不用审核了"
      render "sale_orders/show"
    end
  end

  private


  def get_sale_order
    @sale_order = SaleOrder.find(params[:id])
  end


end

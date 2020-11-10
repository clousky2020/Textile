class PurchaseOrderController < ApplicationController
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params.has_key?(:type)
      type = params[:type].split(":")
      @purchase_orders = PurchaseOrder.includes(:purchase_supplier, :material).purchase_suppliers_search(params[:search]).
          where("#{type[0]}=?", type[1]).references(:purchase_supplier, :material).order('bill_time DESC').page(params[:page])
    elsif params.has_key?(:type)
      type = params[:type].split(":")
      @purchase_orders = PurchaseOrder.includes(:purchase_supplier, :material).is_not_invalid.
          where("#{type[0]}=?", type[1]).references(:purchase_supplier, :material).page(params[:page])
    elsif params.has_key?(:search)
      @purchase_orders = PurchaseOrder.includes(:purchase_supplier, :material).is_not_invalid.
          purchase_suppliers_search(params[:search]).references(:purchase_supplier, :material).page(params[:page])
    else
      @purchase_orders = PurchaseOrder.is_not_invalid.order("updated_at DESC").page(params[:page])
    end
  end

  def new
    @purchase_order = PurchaseOrderCreateForm.new
  end

  def edit
    if !@purchase_order.is_invalid
      if !@purchase_order.check_status
        @purchase_order = PurchaseOrderUpdateForm.new(@purchase_order)
      else
        flash[:warning] = "订单已审核，不可更改"
        render "purchase_order/show"
      end
    else
      flash[:warning] = "订单已作废，不可更改"
      render "purchase_order/show"
    end
  end

  def show
    unless request.referrer =~ /(new|edit)/
      store_referrer_location
    end
    @purchase_order.purchase_supplier.calcu_total_payment_required
  end

  def create
    @purchase_order = PurchaseOrderCreateForm.new
    info = @purchase_order.submit(params[:purchase_orders])
    if info[0]
      flash[:success] = info[1]
      redirect_to purchase_order_url(info[2].id)
    else
      flash[:warning] = "#{(@purchase_order.errors.full_messages << info[1]).join(',')}"
      render "purchase_order/new"
    end
  end

  def update
    if !@purchase_order.check_status
      @purchase_order = PurchaseOrderUpdateForm.new @purchase_order
      if @purchase_order.update(params[:purchase_orders])
        flash[:success] = "成功更新供应订单信息"
        redirect_to purchase_order_url(@purchase_order.id)
      else
        flash[:warning] = "#{@purchase_order.errors.full_messages.join(',')}"
        render "purchase_order/edit"
      end
    else
      flash[:warning] = "订单已审核，不可更改"
      redirect_to purchase_order_url(@purchase_order.id)
    end
  end

  def destroy
    store_referrer_location
    @purchase_order.order_declare_invalid(current_user)
    flash[:success] = "#{@purchase_order.material.purchase_supplier.name}的订单#{@purchase_order.order_id}已作废"
    # PurchaseOrder.delete(@purchase_order)
    redirect_back_referrer_for purchase_order_index_path
  end

  def pass_check
    if !@purchase_order.is_invalid
      @purchase_order.pass_check_result(current_user)
      @purchase_order.purchase_supplier.calcu_total_payment_required
      flash[:success] = "订单号#{@purchase_order.order_id}已审核"
      redirect_back_referrer_for purchase_order_url(@purchase_order.id)
    else
      flash[:warning] = "订单已作废，不可更改"
      render "purchase_order/show"
    end
  end

  private


  def get_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end


end

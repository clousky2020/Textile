class PurchaseSuppliersController < ApplicationController
  before_action :get_supplier, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @suppliers = PurchaseSupplier.search_name(params[:search]).order("name").page(params[:page])
    else
      @suppliers = PurchaseSupplier.order("name").page(params[:page])
    end
  end

  def new
    @supplier = PurchaseSupplier.new
  end

  def edit

  end

  def show
    @purchase_orders = @supplier.purchase_orders.where(is_invalid: false).count
    @expenses = @supplier.expenses.where(is_invalid: false).count
  end

  def create
    @supplier = PurchaseSupplier.new(purchase_supplier_params)
    if @supplier.save
      flash[:success] = "创建成功"
      redirect_to purchase_suppliers_path
    else
      flash[:warning] = "#{@supplier.errors.full_messages.join(',')}"
      render "purchase_suppliers/new"
    end
  end

  def update
    if @supplier.update(purchase_supplier_params)
      # 如果更新了清算金额和日期，重新计算总额
      # if @supplier.check_money > 0 && @supplier.check_money_time
      @supplier.calcu_list
      # end
      flash[:success] = "成功更新供应商信息"
      redirect_to purchase_supplier_url(@supplier)
    else
      flash[:warning] = "#{@supplier.errors.full_messages.join(',')}"
      render "purchase_suppliers/edit"
    end
  end

  def destroy
    if @supplier.purchase_orders.where(check_status: true).blank? && @supplier.expenses.blank?
      PurchaseSupplier.delete(@supplier)
      flash[:warning] = "已经删除供应商#{@supplier.name}了"
      redirect_to purchase_suppliers_path
    else
      flash[:warning] = "该供应商名下下还有关联的采购订单/付款单，不能删除"
      redirect_to purchase_suppliers_path
    end
  end

  def check_purchase_supplier
    @purchase_supplier = PurchaseSupplier.search_name(params[:term]).map(&:name)
    render json: @purchase_supplier
  end

  def export
    @purchase_supplier = PurchaseSupplier.find(params[:id])
    if @purchase_supplier.check_money_time
      purchase_orders = PurchaseOrder.includes(:materials)
                            .where(purchase_supplier_id: params[:id], check_status: true, is_invalid: false)
                            .where("bill_time >=?", @purchase_supplier.check_money_time)
      @purchase_orders = purchase_orders.where(is_return: false)
      @purchase_orders_return = purchase_orders.where(is_return: true)
      @expenses = PurchaseSupplier.select("expenses.bill_time,expenses.paper_amount").joins(:expenses)
                      .where(id: params[:id])
                      .where("bill_time >=? and expenses.check_status=?", @purchase_supplier.check_money_time, true)
    else
      purchase_orders = PurchaseOrder.includes(:materials)
                            .where(purchase_supplier_id: params[:id], check_status: true, is_invalid: false)
      @purchase_orders = purchase_orders.where(is_return: false)
      @purchase_orders_return = purchase_orders.where(is_return: true)
      @expenses = PurchaseSupplier.select("expenses.bill_time,expenses.paper_amount")
                      .joins(:expenses)
                      .where(id: params[:id])
                      .where("check_status=?", true)
    end
    @rows_count = @purchase_orders.size + @purchase_orders_return.size + @expenses.size + 1
    respond_to do |format|
      format.html
      # format.csv {send_data @purchase_order.to_csv}
      format.xls #{send_data @purchase_order.to_csv(col_sep: "\t")}
    end
  end

  private

  def get_supplier
    @supplier = PurchaseSupplier.find(params[:id])
  end

  def purchase_supplier_params
    params.require(:purchase_supplier).permit(:name, :contacts, :phone, :address, :description, :status,
                                              :check_money, :check_money_time)
  end

end

class SaleCustomersController < ApplicationController
  before_action :get_sale_customer, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource
  skip_authorize_resource :only => :check_sale_customer

  def index
    if params.has_key?(:search) && params[:search] != ""
      @sale_customers = SaleCustomer.search_name(params[:search]).order("id").page(params[:page])
    else
      @sale_customers = SaleCustomer.order("id").page(params[:page])
    end
  end

  def new
    @customer = SaleCustomer.new
  end

  def edit

  end

  def show
    @sale_orders = @customer.sale_orders.where(is_invalid: false).count
    @proceeds = @customer.proceeds.where(is_invalid: false).count
  end

  def create
    @customer = SaleCustomer.new(sale_customer_params)
    if @customer.save
      flash[:success] = "创建成功"
      redirect_to sale_customers_path
    else
      flash[:warning] = "#{@customer.errors.full_messages.join(',')}"
      render "sale_customers/new"
    end
  end

  def update
    if @customer.update(sale_customer_params)
      # 如果更新了清算金额和日期，重新计算总额
      # if @customer.check_money > 0 && @customer.check_money_time
      @customer.calcu_list
      # end
      flash[:success] = "成功更新客户信息"
      redirect_to sale_customer_path(@customer)
    else
      flash[:warning] = "#{@customer.errors.full_messages.join(',')}"
      render "sale_customers/edit"
    end
  end

  def check_sale_customer
    @sale_customer = SaleCustomer.search_name(params[:term]).map(&:name)
    render json: @sale_customer
  end

  def destroy
    if @customer.sale_orders.blank? && @customer.proceeds.blank?
      SaleCustomer.delete(@customer)
      flash[:warning] = "已经删除客户#{@customer.name}了"
      redirect_to sale_customers_path
    else
      flash[:warning] = "该客户名下下还有关联的销售订单/收款单，不能删除"
      redirect_to sale_customers_path
    end
  end

  def export
    @sale_customer = SaleCustomer.find(params[:id])
    # 获取该客户下的所有已经审核的订单
    @sale_orders = SaleOrder.includes(:product).where(sale_customer_id: params[:id]).where(check_status: true)
    if @sale_customer.check_money_time
      # 获取在清算日期后的订单
      @sale_orders = @sale_orders.where("bill_time >=?", @sale_customer.check_money_time)
      # 获取该客户的所有收款单
      @proceeds = SaleCustomer.select("proceeds.bill_time,proceeds.paper_amount").joins(:proceeds)
                      .where(id: params[:id]).where("bill_time >=? and proceeds.check_status=?", @sale_customer.check_money_time, true)
    else
      @proceeds = SaleCustomer.select("proceeds.bill_time,proceeds.paper_amount").joins(:proceeds).where(id: params[:id]).where("check_status=?", true)
    end
    # 得到所有退货单
    @sale_orders_return = @sale_orders.where(is_return: true)
    # 得到所有正常销售订单
    @sale_orders_normal = @sale_orders.where(is_return: false)

    @rows_count = @sale_orders.size + @sale_orders_return.size + @proceeds.size + 1
    respond_to do |format|
      format.html
      # format.csv {send_data @purchase_order.to_csv}
      format.xls #{send_data @purchase_order.to_csv(col_sep: "\t")}
    end
  end

  private

  def get_sale_customer
    @customer = SaleCustomer.find(params[:id])
  end

  def sale_customer_params
    params.require(:sale_customer).permit(:name, :contacts, :phone, :address, :description, :status, :check_money, :check_money_time)
  end

end

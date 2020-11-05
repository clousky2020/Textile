class SaleCustomerController < ApplicationController
  before_action :get_sale_customer, only: [:edit, :show, :update, :destroy]
  # load_and_authorize_resource
  # authorize_resource
  skip_authorize_resource :only => :check_sale_customer

  def index

    if params.has_key?(:search) && params[:search] != ""
      @customers = SaleCustomer.where("name LIKE? ", "%#{params[:search]}%").order("name").page(params[:page])
    else
      @customers = SaleCustomer.order("name").page(params[:page])
    end
  end

  def new
    @customer = SaleCustomer.new
  end

  def edit

  end

  def show
    @customer.calcu_total_collection_required
    @customer.calcu_received

  end

  def create
    @customer = SaleCustomer.new(sale_customer_params)
    if @customer.save
      flash[:success] = "创建成功"
      redirect_to sale_customer_index_path
    else
      flash[:warning] = "#{@customer.errors.full_messages.join(',')}"
      render "sale_customer/new"
    end
  end

  def update
    if @customer.update(sale_customer_params)
      flash[:success] = "成功更新客户信息"
      redirect_to sale_customer_path(@customer)
    else
      flash[:warning] = "#{@customer.errors.full_messages.join(',')}"
      render "sale_customer/edit"
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
      redirect_to sale_customer_index_path
    else
      flash[:warning] = "该客户名下下还有关联的订单，不能删除"
      redirect_to sale_customer_index_path
    end
  end


  private

  def get_sale_customer
    @customer = SaleCustomer.find(params[:id])
  end

  def sale_customer_params
    params.require(:sale_customer).permit(:name, :contacts, :phone, :address, :description, :status)
  end

end

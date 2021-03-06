class ProductsController < ApplicationController
  # before_action :get_product, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token, :only => :get_options

  def index
    if params.has_key?(:search) && params[:search] != ""
      @products = Product.where("name LIKE? or specification LIKE?", "%#{params[:search]}%", "%#{params[:search]}%").order("created_at DESC").page(params[:page])
    else
      @products = Product.order("created_at DESC").page(params[:page])
    end
  end

  def new
    @product = Product.new
  end

  def show
    if @product.sale_orders
      dates = @product.sale_orders.select(:bill_time, :price).where(is_invalid: false, check_status: true)
      @bill_times = dates.map(&:bill_time)
      @prices = dates.map(&:price)
    end
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "创建成功"
      redirect_to products_url
    else
      flash[:warning] = "#{@product.errors.full_messages.join(',')}"
      render "products/new"
    end
  end


  def update
    if @product.update(product_params)
      flash[:success] = "成功更新产品信息"
      redirect_to product_url(@product)
    else
      flash[:warning] = "#{@product.errors.full_messages.join(',')}"
      render "products/edit"
    end
  end

  def destroy
    if @product.sale_orders.blank?
      Product.delete(@product)
    else
      flash[:warning] = "该产品还有相关的订单，无法删除"
    end
    redirect_to products_path
  end

  def get_options
    @product_names = Product.find(params[:id])
  end

  private

  def get_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :specification, :measuring_unit, :preset_cost, :preset_price, :remarks)
  end
end

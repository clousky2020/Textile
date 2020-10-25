class ProductController < ApplicationController

  before_action :get_product, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @products = Product.where("name LIKE?", "%#{params[:search]}%").order("created_at DESC").page(params[:page])
    else
      @products = Product.order("created_at DESC").page(params[:page])
    end
  end

  def new
    @product = Product.new
  end

  def show
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "创建成功"
      redirect_to product_index_url
    else
      flash[:warning] = "#{@product.errors.full_messages.to_s}"
      render "product/new"
    end
  end


  def update
    if @product.update(product_params)
      flash[:success] = "成功更新产品信息"
      redirect_to product_url(@product)
    else
      flash[:warning] = "#{@product.errors.full_messages.to_s}"
      render "product/edit"
    end
  end

  def destroy
    Product.delete(@product)
    redirect_to product_index_path
  end

  private

  def get_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :specification, :measuring_unit, :preset_cost, :preset_price, :remarks)
  end
end

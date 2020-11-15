class MaterialController < ApplicationController
  before_action :get_material, only: [:edit, :show, :update, :destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @materials = Material.joins(:purchase_supplier).search(params[:search]).order("updated_at DESC").page(params[:page])
    else
      @materials = Material.order("updated_at DESC").page(params[:page])
    end
  end

  def new
    @material = Material.new
    @material.build_purchase_supplier
  end

  def show
    if @material.purchase_orders
      orders = @material.purchase_orders.select(:bill_time, :price).where(is_invalid: false, check_status: true)
      @bill_times = orders.map(&:bill_time)
      @prices = orders.map(&:price)
    end
  end

  def edit
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      flash[:success] = "创建成功"
      redirect_to material_index_url
    else
      flash[:warning] = "#{@material.errors.full_messages.join(',')}"
      render "material/new"
    end
  end


  def update
    if @material.update(material_params)
      flash[:success] = "成功更新原材料信息"
      redirect_to material_url(@material)
    else
      flash[:warning] = "#{@material.errors.full_messages.join(',')}"
      render "material/edit"
    end
  end

  def destroy
    Material.delete(@material)
    redirect_to material_index_path
  end

  def check_material_name
    @material_names = Material.search_name(params[:term]).map(&:name)
    render json: @material_names
  end

  def check_material_specification
    @material_specifications = Material.search_specification(params[:term]).map(&:specification)
    render json: @material_specifications
  end


  private

  def get_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:name, :description, :type, :specification, :batch_number, :measuring_unit, :tax_rate,
                                     :preset_price, :remarks, :status, :picture, :purchase_supplier_attributes => [:id, :name])
  end

end

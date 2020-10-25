class MaterialController < ApplicationController
  before_action :get_material,only: [:edit,:show,:update,:destroy]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @materials = Material.where("name LIKE?", "%#{params[:search]}%").order("created_at DESC").page(params[:page])
    else
      @materials = Material.order("created_at DESC").page(params[:page])
    end
  end

  def new
    @material = Material.new
  end

  def show
  end

  def edit
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      flash[:success] = "创建成功"
      redirect_to material_index_url
    else
      flash[:warning] = "#{@material.errors.full_messages.to_s}"
      render "material/new"
    end
  end


  def update
    if @material.update(material_params)
      flash[:success] = "成功更新原材料信息"
      redirect_to material_url(@material)
    else
      flash[:warning] = "#{@material.errors.full_messages.to_s}"
      render "material/edit"
    end
  end

  def destroy
    Material.delete(@material)
    redirect_to material_index_path
  end

  private

  def get_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:name, :description, :type, :specification, :batch_number, :measuring_unit, :tax_rate,
                                     :preset_price, :remarks, :status, :picture,)
  end

end

class OutputsController < ApplicationController
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @outputs = Output.joins(:product).search(params[:search]).order("output_date DESC").page(params[:page])
    else
      @outputs = Output.order("output_date DESC").page(params[:page])
    end
  end

  def new
    @product = Product.select(:id, :specification)
    @employee = Employee.where(status: true).where("work_type=?","挡车工").select(:id, :work_id)
  end

  def show

  end

  def edit

  end

  def create
    if params[:record].present?
      flash[:info] = Output.outputs_save(params)
      if flash[:info] == "成功创建"
        redirect_to outputs_path
      else
        @product = Product.select(:id, :specification)
        @employee = Employee.where(status: true).select(:id, :work_id)
        redirect_back_referrer_for outputs_path
      end
    end
  end

  def destroy
    output_id = Output.find(params[:id])
    output_id.delete
  end

  def delete_list
    params[:ids].each do |output_id|
      output_id = Output.find(output_id)
      output_id.delete
      output_id.reduce_the_product
    end
    redirect_to outputs_path
  end
end

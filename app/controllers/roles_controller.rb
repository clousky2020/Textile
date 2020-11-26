class RolesController < ApplicationController
  before_action :set_role, only: %i[show edit update destroy]
  load_and_authorize_resource
  def index
    @roles = Role.all.order("id")
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_url, notice: "角色成功创建"
    else
      render :new
    end
  end

  def update
    if @role.update(role_params)
      redirect_to roles_url, notice: "角色成功更新"
    else
      render :edit
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_url, notice: "角色已删除"
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :description, permissions_attributes: {})
  end
end

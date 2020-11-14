class RepoController < ApplicationController
  before_action :get_repo, only: [:edit, :show, :update, :destroy]
  before_action :get_warehouses, only: [:new, :edit]
  load_and_authorize_resource

  def index
    if params.has_key?(:search) && params[:search] != ""
      @repos = Repo.where("name LIKE?", "%#{params[:search]}%").order("name").page(params[:page])
    else
      @repos = Repo.order("name").page(params[:page])
    end
  end

  def new
    @repos = Repo.new
  end

  def edit
  end

  def show

  end

  def create
    @repo = Repo.new(repo_params)
    if @repo.save
      flash[:success] = "创建成功"
      redirect_to repo_index_path
    else
      flash[:warning] = "#{@repo.errors.full_messages.join(',')}"
      render "repo/new"
    end
  end

  def update
    if @repo.update(repo_params)
      flash[:success] = "成功更新仓库信息"
      redirect_to repo_url(@repo)
    else
      flash[:warning] = "#{@repo.errors.full_messages.join(',')}"
      render "repo/edit"
    end
  end

  def destroy
    if Repo.all.count > 1
      Repo.delete(@repo)
    else
      flash[:danger] = "最后一个仓库不能删除"
    end
    redirect_to repo_index_path
  end

  private

  #联表查询，得到仓库管理员
  def get_warehouses
    @warehouses = User.joins(:roles).where(roles: {name: "warehouse"})
  end

  def get_repo
    @repo = Repo.find(params[:id])
  end

  def repo_params
    params.require(:repo).permit(:name, :address, :description, :admin_id, :user_id, :status)
  end

end

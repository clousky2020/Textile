class UserController < ApplicationController
  # before_action :get_user, only: :lock
  load_and_authorize_resource

  def index
    @users = User.order("id").page(params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @expenses = Expense.where(user_id: @user.id).where("need_reimburse=? or reimbursed=?", true, true)
  end

  def edit

  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "创建成功"
      redirect_to user_index_url
    else
      flash[:warning] = "#{@user.errors.full_messages.join(',')}"
      render "user/new"
    end
  end


  def update
    if @user.update(user_params)
      flash[:success] = "成功更新用户信息"
      redirect_to user_url(@user)
    else
      flash[:warning] = "#{@user.errors.full_messages.join(',')}"
      render "user/edit"
    end
  end

  def destroy
    User.delete(@user)
    redirect_to user_index_path
  end

  def lock
    @user.get_locked
    redirect_to user_index_path
  end

  def reset
    @user.password = "123456"
    if @user.save
      flash[:success] = "密码已经重置为#{@user.password}"
    else
      flash[:danger] = "#{@user.errors.full_messages.join(',')}"
    end
    redirect_to user_index_path
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :is_lock, :email, role_ids: [])
  end
end

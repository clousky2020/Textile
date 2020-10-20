class UserController < ApplicationController
  load_and_authorize_resource


  def index
    if params.has_key?(:search) && params[:search] != ""
      @user = User.where("name LIKE?", "%#{params[:search]}%").order("work_id").page(params[:page]).per(10)
    elsif params[:order] == "all"
      @user = User.order("work_id").page(params[:page]).per(10)
    else
      @user = User.where("work_status=?", "在职").order("work_id").page(params[:page]).per(10)
    end
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "创建成功"
      redirect_to user_index_url
    else
      flash[:warning] = "#{@user.errors.full_messages.to_s}"
      render "user/new"
    end
  end


  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "成功更新员工信息"
      redirect_to user_url(@user)
    else
      flash[:warning] = "#{@user.errors.full_messages.to_s}"
      render "user/edit"
    end
  end

  def destroy

  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :work_id, :work_type, :basic_wage, :minimun_wage, :house_allowance,
                                 :other_allowance, :phone, :bank_card, :work_status, :entry_date, :daparture_date,
                                 :remarks, :role)
  end
end
